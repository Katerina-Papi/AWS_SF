import requests
import json

def get_crime_data():
    url = 'https://data.police.uk/api/crimes-street/all-crime'
    params = {
        'poly': '52.268,0.543:52.794,0.238:52.130,0.478',
        'date': '2024-03'
    }

    try:
        response = requests.get(url, params=params)
        response.raise_for_status()  # Raise an exception for HTTP errors
        crime_data = response.json()
        return crime_data
    except requests.exceptions.RequestException as e:
        print(f"Error retrieving crime data: {e}")
        return None

def save_to_file(data, filename):
    with open(filename, 'w') as file:
        json.dump(data, file)

if __name__ == '_main_':
    crime_data = get_crime_data()
    if crime_data:
        print("Crime data retrieved successfully.")
        save_to_file(crime_data, 'crime_data.json')
        print("Crime data saved to 'crime_data.json'.")
    else:
        print("Failed to retrieve crime data.")
