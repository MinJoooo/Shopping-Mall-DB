import pymysql
import requests
from bs4 import BeautifulSoup


# ********** save_data **********
def save_data(data):
    sql = "SELECT COUNT(*) FROM ITEM_INFO WHERE item_code = '" + data['item_code'] + "';"
    cursor.execute(sql)
    result = cursor.fetchone()

    sql = """
        INSERT INTO ITEM_INFO VALUES(
        """ + str(data['item_index']) + """,
        '""" + data['item_code'] + """',
        '""" + data['item_title'] + """', 
        '""" + data['item_provider'] + """', 
        """ + str(data['original_price']) + """
        )"""
    if result[0] == 0:
        cursor.execute(sql)

    sql = """
        INSERT INTO ITEM_DISCOUNT VALUES(
        """ + str(data['item_index']) + """,
        """ + str(data['discount_rate']) + """,
        """ + str(data['discount_price']) + """
        )"""
    cursor.execute(sql)

    sql = """
        INSERT INTO SCORE VALUES(
        """ + str(data['item_index']) + """,
        """ + str(data['discount_rate']) + """,
        """ + str('0') + """,
        """ + str('0') + """,
        """ + str(data['discount_rate']) + """
        )"""
    cursor.execute(sql)


# ********** get_items **********
def get_items(html):
    best_item = html.select('div.best-list')

    if len(best_item[1].select('li')) > 0:
        for index, item in enumerate(best_item[1].select('li')):

            data_dict = dict()

            item_title = item.select_one('a.itemname')
            original_price = item.select_one('div.o-price')
            discount_price = item.select_one('div.s-price strong span')
            discount_rate = item.select_one('div.s-price em')

            if original_price == None or original_price.get_text() == '':
                original_price = discount_price

            if discount_price == None:
                original_price, discount_price = 0, 0
            else:
                original_price = original_price.get_text().replace(',', '').replace('원', '')
                discount_price = discount_price.get_text().replace(',', '').replace('원', '')

            if discount_rate == None or discount_rate.get_text() == '':
                discount_rate = 0
            else:
                discount_rate = discount_rate.get_text().replace('%', '')

            product_link = item.select_one('div.thumb > a')
            item_code = product_link.attrs['href'].split('=')[1].split('&')[0]

            res = requests.get(product_link.attrs['href'])
            soup = BeautifulSoup(res.content, 'html.parser')
            provider = soup.select_one('div.item-topinfo_headline > p > a > strong')

            if provider == None:
                provider = ''
            else:
                provider = provider.get_text()

            data_dict['item_index'] = index + 1
            data_dict['item_code'] = item_code
            data_dict['item_title'] = item_title.get_text()
            data_dict['item_provider'] = provider
            data_dict['original_price'] = original_price
            data_dict['discount_rate'] = discount_rate
            data_dict['discount_price'] = discount_price

            save_data(data_dict)
            print(index + 1, 'data done!')

####################################################################################
#########################       CHANGE THIS CODE !!!       #########################
####################################################################################

            if (index + 1) == 10:
                break


# ******************************
# Running
# ******************************

db = pymysql.connect(host='127.0.0.1', port=3306, user='root', passwd='asdf1234', db='item_ranking', charset='utf8')
cursor = db.cursor()

res = requests.get('http://corners.gmarket.co.kr/Bestsellers')
soup = BeautifulSoup(res.content, 'html.parser')

get_items(soup)

db.commit()
db.close()