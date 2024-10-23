# -*- coding: utf-8 -*-
"""
Created on Mon Oct 21 21:34:22 2024

@author: JSR
"""

import pandas as pd
import re
import unidecode

from pathlib import Path

input_path = Path(__file__).resolve().parent / 'dataset' / 'raw'
output_path = Path(__file__).resolve().parent / 'dataset' / 'cleaned'

reviews = pd.read_csv(input_path / 'olist_order_reviews_dataset.csv')
orders = pd.read_csv(input_path / 'olist_orders_dataset.csv')
products = pd.read_csv(input_path / 'olist_products_dataset.csv')
sellers = pd.read_csv(input_path / 'olist_sellers_dataset.csv', dtype={'seller_zip_code_prefix': str}) #zip_code_prefixes have leading zeroes
translation = pd.read_csv(input_path / 'product_category_name_translation.csv')
geolocation = pd.read_csv(input_path / 'olist_geolocation_dataset.csv', dtype={'geolocation_zip_code_prefix': str})
customers = pd.read_csv(input_path / 'olist_order_customers_dataset.csv', dtype={'customer_zip_code_prefix': str})
items = pd.read_csv(input_path / 'olist_order_items_dataset.csv')
payments = pd.read_csv(input_path / 'olist_order_payments_dataset.csv')

dfs = {
    'reviews': reviews,
    'orders': orders, 
    'products': products,
    'sellers': sellers,
    'translation': translation,
    'geolocation': geolocation,
    'customers': customers,
    'items': items,
    'payments': payments
}

# inspect columns
for name, df in dfs.items():
    dtypes = df.dtypes
    dtypes_dict = dtypes.apply(lambda x: str(x)).to_dict()
    
    print(f"{name}:")
    for col, dtype in dtypes_dict.items():
        print(f" - {col}: {dtype}")

# product_name_lenght and product_description_lenght columns are mispelled,
# rename to avoid error in the future
products.rename(columns={
                        'product_name_lenght': 'product_name_length',
                         'product_description_lenght' : 'product_description_length'
                         }, inplace=True)

# Check for 'invalid' characters across all dataframe
def get_invalid_chars(dfs):
    invalid_chars_report = {}

    for name, df in dfs.items():
        invalid_columns_info = {}
        for col in df.columns:
            invalid_chars_set = set()            
            for value in df[col]:
                if isinstance(value, str):
                    invalid_chars = re.findall(r'[^a-zA-Z0-9 ]', value)  # Find non-alphanumeric characters excluding space
                    invalid_chars_set.update(invalid_chars)
            if invalid_chars_set:
                invalid_columns_info[col] = list(invalid_chars_set)
        if invalid_columns_info:
            invalid_chars_report[name] = invalid_columns_info
    for df_name, invalid_columns in invalid_chars_report.items():
        print(f"{df_name}:\n: {invalid_columns}")

    return invalid_chars_report

dfs_chars = get_invalid_chars(dfs)

# Check for duplicate rows across dataframes
def get_duplicates(dfs):
    duplicates_list = []
    
    for df_name, df in dfs.items():
        duplicates = df[df.duplicated(keep=False)]  # Get all duplicate rows
        if not duplicates.empty:  # Only add if there are duplicates
            duplicates_list.append((df_name, duplicates))
            
    for df_name, dup_df in duplicates_list:
        print(f"Duplicates in {df_name}:\n", dup_df, "\n")
    
    return duplicates_list

duplicate_rows_dfs = get_duplicates(dfs)

# Replace empty strings or spaces with NaN
def space_to_null(dfs):
    for name, df in dfs.items():
        df.replace(r'^\s*$', pd.NA, regex=True, inplace=True)
        print(f"Processed {name}: Replaced empty strings with null")

cleaned_df = space_to_null(dfs)

# There are duplicates in geolocation df, but some are not detected due to
# different latitude, longitudes, and spelling of cities (some have special characters)
geolocation['unaccented'] = geolocation['geolocation_city'].apply(unidecode)
geolocation.sort_values(by=['geolocation_zip_code_prefix', 'geolocation_lat', 'geolocation_lng', 'geolocation_state', 'unaccented'], inplace=True)     
geolocation = geolocation.drop_duplicates(subset=['geolocation_zip_code_prefix', 'geolocation_state'], keep='first')
geolocation = geolocation.drop(['unaccented'], axis=1)

# Save cleaned dfs
for name, df in dfs.items():
        file_path = output_path / f'olist_{name}.csv'
        df.to_csv(file_path, index=False)
        print(f"Saved {name} to {file_path}")