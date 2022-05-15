DROP VIEW IF EXISTS RANKING;
DROP VIEW IF EXISTS WHO_BOUGHT;

CREATE VIEW RANKING AS
SELECT RANK() OVER(ORDER BY score DESC) AS ranking,
	II.item_index, II.item_code, II.item_title, II.item_provider,
	II.original_price, ID.discount_rate, ID.discount_price, score
FROM ITEM_INFO AS II, ITEM_DISCOUNT AS ID, SCORE AS S
WHERE II.item_index = ID.item_index AND II.item_index = S.item_index
ORDER BY score DESC, ID.discount_rate DESC;

CREATE VIEW WHO_BOUGHT AS
SELECT customer_index, item_index
FROM ITEM_BUY_INFO
ORDER BY customer_index;