import random

import pandas as pd
from invoke import task
from mimesis import Address, Datetime
from mimesis.locales import Locale
from mimesis.schema import Field, Schema


@task
def data(c):
    address = Address()
    _ = Field(locale=Locale.IT)
    location_schema = Schema(schema=lambda: {
        "locationId": _("increment"),
        "city": address.city(),
        "province": address.province(),
        "region": address.region(),
    })
    locations = [location for location in location_schema.iterator(10)]
    df = pd.DataFrame.from_records(locations)
    df.to_csv("./homework1/data/location.csv", index=False)

    _ = Field(locale=Locale.IT)
    museum_schema = Schema(schema=lambda: {
        "museumID": _("increment"),
        "locationID": random.randint(1, 10),
        "category": random.choice(["Arts", "History sites", "Natural history"]),
        "guidedTours": random.randint(0, 1),
        "audioGuides": random.randint(0, 1),
        "Wardrobe": random.randint(0, 1),
        "Cafe": random.randint(0, 1),
        "Wifi": random.randint(0, 1),
    })
    museums = [museum for museum in museum_schema.iterator(20)]
    df = pd.DataFrame.from_records(museums)
    df.to_csv("./homework1/data/museum.csv", index=False)

    times = [generate_dates(i + 1) for i in range(10000)]
    df = pd.DataFrame.from_records(times)
    df.to_csv("./homework1/data/timeDim.csv", index=False)

    _ = Field(locale=Locale.IT)
    ticket_schema = Schema(schema=lambda: {
        "timeID": _("increment"),
        "museumID": random.randint(1, 20),
        "totalAmount": random.randint(5, 20),
        "numberOfTickets": random.randint(1, 5),
        "purchaseModality": random.choice(["online", "offices", "entrance"]),
        "ticketType": random.choice(["full", "student", "junior"]),
        "timeSlot": random.randint(1, 3),
    })

    sales = [spec_time for spec_time in ticket_schema.iterator(10000)]
    df = pd.DataFrame.from_records(sales)
    df.to_csv("./homework1/data/sale.csv", index=False)


def generate_dates(time_id):
    random_date = Datetime().date()
    month = random_date.month
    return {
        "timeID": time_id,
        "validDate": random_date.strftime("%Y/%m/%d"),
        "month": random_date.strftime("%m-%Y"),
        "bimester": month // 2,
        "trimester": month // 3,
        "semester": month // 6,
        "year": random_date.year,
        "workingDay": random_date.weekday() <= 5,
    }
