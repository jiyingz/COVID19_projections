#this data was sourced from Our Word in Data @ https://ourworldindata.org/coronavirus https://github.com/owid/covid-19-data

import pandas as pd

def main():
	owid_data = pd.read_csv("~/.../Data/owid-covid-data.csv")
	owid_data = owid_data[['location', 'date', 'total_cases', 'total_deaths']]
	owid_data.rename(columns={'location' : 'country', 'total_cases': 'cases', 'total_deaths': 'deaths'}, inplace=True)
	owid_data.to_csv("~/.../Data/owid_data.csv", index = False)



if __name__ == '__main__':
	main()