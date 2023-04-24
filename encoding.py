import pandas as pd 
my_headers = ['ip','domain', 'URL', 'organization', 'number', 'date']
df = pd.read_csv('dump.csv', encoding='windows-1251', sep=';', header=0, names=my_headers)
# print(df.head())
df.to_csv('dump_output.csv', index=False, sep=';', encoding='utf-8')