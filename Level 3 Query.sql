/* Question Set 3 - Advance */

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */
WITH cte as(
	select artist.artist_id,artist.name,
	sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
	from invoice_line
	join track on track.track_id=invoice_line.track_id
	join album on album.album_id=track.album_id
	join artist on artist.artist_id=album.artist_id
	group by 1
	order by 3 desc
)
select customer.customer_id,customer.first_name,customer.Last_name,b.name, 
sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
from invoice
join customer on customer.customer_id=invoice.customer_id
JOIN invoice_line  ON invoice_line .invoice_id = invoice.invoice_id
JOIN track  ON track.track_id = invoice_line.track_id
JOIN album  ON album.album_id = track.album_id
JOIN cte b ON b.artist_id = album.artist_id
group by 1,2,3,4
order by 5 desc


/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id,
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre where RowNo=1;



/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

with cte as(
	select customer.customer_id,customer.first_name,billing_country ,sum(total) as totalspent,
	ROW_NUMBER() over(partition by billing_country order by sum(total) desc) as Row_No
	from customer
	join invoice on customer.customer_id=invoice.customer_id
	group by 1,2,3
	order by 3 desc ,4 desc
)
select * from cte where Row_No=1;
