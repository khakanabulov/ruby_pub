# /api/debtors/1 => response.csv ('ФИО', 'Дата рождения', 'Код региона')

# /api/fsin/николаев+алек => json:
```json
[
  {
    "fio": "Алексеев Алексей Николаевич",
    "dt": "27.05.1982"
  },
  {
    "fio": "Гилёв Алексей Николаевич",
    "dt": "22.01.1976"
  },
  {
    "fio": "Крылов Александр Николаевич",
    "dt": "04.04.1971"
  }
]
```
# /api/inn/1234567890 => json:
```json
{
  "error":"",
  "finesList":[
    {
      "koapSt":"",
      "koapText":"",
      "fineDate":"",
      "sum":0,
      "billId":"",
      "hasDiscount":0,
      "hasPhoto":0,
      "divId":0,
      "discountSum":0,
      "discountUntil":""
    }]
}
```

# /api/arbitr/1234567890 => json:
```json
[
  {
    "link": "https://kad.arbitr.ru/Card/12752b95-df28-4f70-8bc3-725cc60827f0",
    "num": "А41-62108/2014",
    "judge": "Гринева А. В.",
    "title": "АС Московской области",
    "name": "Ип Витвицкий Дмитрий Владимирович",
    "dt": "08.10.2014"
  }
]
```
[comment]: <> (
Arbitr:{"Cases":[{"CaseId":"","CaseNumber":"","CaseType":"","Thirds":[{"inn":"","name":"","count":0}],"Plaintiffs":[{"inn":"","name":"","count":0}],"Respondents":[{"inn":"","name":"","count":0}],"Others":[{"inn":"","name":"","count":0}],"StartDate":"","Finished":false,"State":"","CaseInstances":"","CourtHearings":null}],"PagesCount":0,"error":""}
Пример: АБАКУМЕЦ СЕРГЕЙ ВАСИЛЬЕВИЧ 23.02.1980 0804274140  
)
# /api/nalog/1234567890 => json:
```json
{
  "captchaRequired": false,
  "ip": {
    "hasMore": false,
    "page": 1,
    "pageSize": 10,
    "data": [
      {
        "yearcode": 2020,
        "periodcode": 12,
        "ogrn": "333",
        "inn": "555",
        "okved2": "62.01",
        "okved2name": "Разработка компьютерного программного обеспечения",
        "namec": "ВЛАДИМИР",
        "token": "aaa"
      },
      {
        "yearcode": 2020,
        "periodcode": 12,
        "ogrn": "333",
        "inn": "555",
        "okved2": "47.52.7",
        "okved2name": "Торговля розничная строительными материалами",
        "namec": "ВЛАДИМИР",
        "token": "aaa"
      }
    ],
    "rowCount": 2
  }
}
```

[comment]: <> (
Дисквалификация:
{"success":0,
"dis":[{"number":"","name":"","date_of_birth":"","place_of_birth":"","name_org":"","position":"","article":"","creator":"","court":"","period":"","start_date":"","end_date":""}],
"error":""}
Пример: ИНН - 5205037677
-
ИП:
{"success":0,"ip":[{"ogrn":"","okved":"","okved_name":"","name":""}],"error":""}
Пример: ИНН - 772830410106
-
Учредителей и гендиректоров
{"success":0,"director":[{"inn":"","name":"","count":0}],"owner":[{"inn":"","name":"","count":0}],"error":""}
Пример: ИНН - 502419236001
-
Ограничение:
{"success":0,"limit_org":[{"name":"","inn":"","position":"","reason":"","start_date":"","end_date":"","org_name":"","org_inn":""}],"error":""}
Пример: ИНН - 5205037677
)
