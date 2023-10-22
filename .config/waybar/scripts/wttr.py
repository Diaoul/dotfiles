#!/usr/bin/env python

import sys
import json
import requests
from datetime import datetime

# from https://github.com/chubin/wttr.in/blob/master/lib/constants.py
WWO_CODE = {
    "113": "Sunny",
    "116": "PartlyCloudy",
    "119": "Cloudy",
    "122": "VeryCloudy",
    "143": "Fog",
    "176": "LightShowers",
    "179": "LightSleetShowers",
    "182": "LightSleet",
    "185": "LightSleet",
    "200": "ThunderyShowers",
    "227": "LightSnow",
    "230": "HeavySnow",
    "248": "Fog",
    "260": "Fog",
    "263": "LightShowers",
    "266": "LightRain",
    "281": "LightSleet",
    "284": "LightSleet",
    "293": "LightRain",
    "296": "LightRain",
    "299": "HeavyShowers",
    "302": "HeavyRain",
    "305": "HeavyShowers",
    "308": "HeavyRain",
    "311": "LightSleet",
    "314": "LightSleet",
    "317": "LightSleet",
    "320": "LightSnow",
    "323": "LightSnowShowers",
    "326": "LightSnowShowers",
    "329": "HeavySnow",
    "332": "HeavySnow",
    "335": "HeavySnowShowers",
    "338": "HeavySnow",
    "350": "LightSleet",
    "353": "LightShowers",
    "356": "HeavyShowers",
    "359": "HeavyRain",
    "362": "LightSleetShowers",
    "365": "LightSleetShowers",
    "368": "LightSnowShowers",
    "371": "HeavySnowShowers",
    "374": "LightSleetShowers",
    "377": "LightSleet",
    "386": "ThunderyShowers",
    "389": "ThunderyHeavyRain",
    "392": "ThunderySnowShowers",
    "395": "HeavySnowShowers",
}

WEATHER_SYMBOL = {
    "Unknown":             "✨",
    "Cloudy":              "☁️",
    "Fog":                 "🌫",
    "HeavyRain":           "🌧",
    "HeavyShowers":        "🌧",
    "HeavySnow":           "❄️",
    "HeavySnowShowers":    "❄️",
    "LightRain":           "🌦",
    "LightShowers":        "🌦",
    "LightSleet":          "🌧",
    "LightSleetShowers":   "🌧",
    "LightSnow":           "🌨",
    "LightSnowShowers":    "🌨",
    "PartlyCloudy":        "⛅️",
    "Sunny":               "☀️",
    "ThunderyHeavyRain":   "🌩",
    "ThunderyShowers":     "⛈",
    "ThunderySnowShowers": "⛈",
    "VeryCloudy": "☁️",
}


CHANCE_SYMBOL = {
    "chanceoffog": "🌫",
    "chanceoffrost": " ",
    "chanceofrain": "🌧",
    "chanceofsnow": "🌨",
    "chanceofthunder": "⛈ ",
    "chanceofwindy": " ",
}

WEATHER_CODES = {k: WEATHER_SYMBOL[v] for k, v in WWO_CODE.items()}


def index_to_text(i :int):
    if i == 0:
        return "Hourly"
    if i == 1:
        return "Tomorrow"
    return "Later"


def format_chances(data):
    conditions = []
    for key in CHANCE_SYMBOL.keys():
        if int(data[key]) > 0:
            conditions.append(f"{CHANCE_SYMBOL[key]} {data[key]}%")

    if not conditions:
        return ""

    return " / ".join(conditions)


def main(location: str):
    weather = requests.get(f"https://wttr.in/{location}?format=j1").json()

    location = weather["nearest_area"][0]["areaName"][0]["value"]
    icon = WEATHER_CODES[weather['current_condition'][0]['weatherCode']]
    description = weather['current_condition'][0]['weatherDesc'][0]['value']
    temperature = weather['current_condition'][0]['temp_C']
    feels_like_temperature = weather['current_condition'][0]['FeelsLikeC']
    minimum_temperature = weather['weather'][0]['mintempC']
    maximum_temperature = weather['weather'][0]['maxtempC']
    humidity = weather['current_condition'][0]['humidity']
    wind_speed = weather['current_condition'][0]['windspeedKmph']
    wind_direction = weather['current_condition'][0]['winddir16Point']

    text = f"{icon} {temperature}°C"

    tooltip = (
        f"<big>{temperature}°C {icon} {description}</big>\n"
        f"<small>Feels like {feels_like_temperature}°C</small>\n"
        f" {minimum_temperature} - {maximum_temperature}°C\n"
        f"  {wind_speed} km/h {wind_direction}\n"
        f" {humidity}%\n"
    )
    for i, day in enumerate(weather['weather']):
        # only today and tomorrow
        if i > 1:
            break
        tooltip += f"<span size=\"xx-large\">{index_to_text(i)}</span>\n"

        minimum_temperature = day['mintempC']
        maximum_temperature = day['maxtempC']
        if i > 0:
            tooltip += f" {minimum_temperature} - {maximum_temperature}°C\n"

        for hour in day['hourly']:
            # only future hours for today
            if i == 0 and int(hour['time'].replace('00', '')) < datetime.now().hour - 2:
                continue

            time = hour['time'].replace('00', '').zfill(2)
            icon = WEATHER_CODES[hour['weatherCode']]
            description = hour['weatherDesc'][0]['value']
            temperature = hour['tempC']
            chances = format_chances(hour)
            tooltip += f"{time}h  {temperature}°C {icon} {description}  {format_chances(hour)}\n"

    return text, tooltip

try:
    text, tooltip = main(sys.argv[1])
    print(json.dumps({"text": text, "tooltip": tooltip}))
except Exception as e:
    import traceback
    tb = traceback.format_exc()
    print(json.dumps({"text": "...", "tooltip": f"{e}\n{tb}"}))
