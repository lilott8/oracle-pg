create view sales_view as
select rownum as sales_id, sales.* from sales;
