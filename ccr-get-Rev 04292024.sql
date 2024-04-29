-- get water service rates
select 
 distinct
 service_code,
 [description]
 INTO #WATERSERVICERATE
from ub_service
where
 SUBSTRING(service_code,1,2) not in ('SB', 'SF', 'SW', 'BF','OF','FI','RW','SC','WC','SX','TA','0')

--select * from #WATERSERVICERATE

-- get active water accounts
select 
 distinct
 l.misc_2,
 mast.billing_cycle,
 replicate('0', 6 - len(mast.cust_no)) + cast (mast.cust_no as varchar)+ '-'+replicate('0', 3 - len(mast.cust_sequence)) + cast (mast.cust_sequence as varchar) as AccountNum,
 bt.email,
 bt.send_paper_bill,
 bt.web_pmts_no_paper_bill,
 mast.reoccuring_web_pmts
from ub_master mast
inner join
 ub_service_rate sr
 on sr.cust_no=mast.cust_no
 and sr.cust_sequence=mast.cust_sequence
 and sr.service_code in (
  select 
   distinct
   service_code
  from #WATERSERVICERATE
 )
inner join
 ub_bill_to bt
 on bt.cust_no=mast.cust_no
 and bt.cust_sequence=mast.cust_sequence
 and  mast.acct_status='active'
 and statement_name='Billing Statement'
inner join
	lot l
	on mast.lot_no=l.lot_no
	and l.misc_5 not in (
	'Army',
	'ArmyConstruction',
	'CSUMB',
	'Fitch Park',
	'Frederick Park',
	'Hayes Park',
	'Marshall Park',
	'Schoonover I',
	'Schoonover II',
	'Stilwell Park',
	'Sun Bay'
	)
	and l.misc_5 not like '%construction%'
	and misc_16 not like 'Irrigation'



 drop table #WATERSERVICERATE

 select *
 from lot

