use Weather
ALTER TABLE AQS_Sites ALTER COLUMN State_Code  VARCHAR(50) NOT NULL
ALTER TABLE AQS_Sites ALTER COLUMN County_Code VARCHAR(50) NOT NULL
ALTER TABLE AQS_Sites ALTER COLUMN Site_Number VARCHAR(50) NOT NULL
ALTER TABLE AQS_Sites ADD PRIMARY KEY (State_Code,County_Code,Site_Number)
ALTER TABLE Temperature ALTER COLUMN State_Code  VARCHAR(50) NOT NULL
ALTER TABLE Temperature ALTER COLUMN County_Code VARCHAR(50) NOT NULL
ALTER TABLE Temperature ALTER COLUMN Site_Num    VARCHAR(50) NOT NULL

-- ALTER TABLE temperature alter column Date_Local  date null drop index
-- idx_date

ALTER TABLE Temperature ADD FOREIGN KEY (State_Code,County_Code,Site_Num) REFERENCES AQS_Sites(State_Code,County_Code,Site_Number)

------------------------------- 
-----Question_#1
-------------------------------

SELECT
    FORMAT(MIN(Date_Local),'yyyy-MM-dd') AS 'First Date' , FORMAT(MAX(Date_Local),'yyyy-MM-dd') AS 'Last Date'
    FROM
        Temperature

	--  Question_#2

	SELECT
	    State_Name , MIN(Average_Temp) AS 'Minimum Temp' , MAX(Average_Temp) AS 'Maximum Temp' , AVG(Average_Temp) AS 'Average Temp'
	    FROM
	        Temperature Te , AQS_Sites Aq
		WHERE
		    Te.State_Code     =Aq.State_Code
		        AND Te.County_Code=Aq.County_Code
			    AND Te.Site_Num   =Aq.Site_Number
			    GROUP BY
			        State_Name
				ORDER BY
				    State_Name


				    --  Question_#3

				    SELECT
				        aq.State_Name, aq.State_Code , aq.County_Code , aq.Site_Number
					  , MIN(Average_Temp) AS Average_Temp , FORMAT(MAX(Date_Local),'yyyy-MM-dd') AS 'DATE_LOCAL'
					  FROM
					      AQS_Sites aq , Temperature te
					      WHERE
					          Te.State_Code = aq.State_Code
						      AND te.County_Code = aq.County_Code
						          AND te.Site_Num = aq.Site_Number
							  GROUP BY
							      aq.State_Name , aq.State_Code , aq.County_Code , aq.Site_Number
							        , Average_Temp , Date_Local
								HAVING
								    (
								            Average_Temp    <-39
									            OR Average_Temp > 105
										        )
											ORDER BY
											    State_Name DESC , Average_Temp


											    -- Question_#4

											    Delete
											    From
											        Temperature
												Where
												    Average_Temp    < -39
												        OR Average_Temp > 125
													Delete
													From
													    Temperature
													    Where
													        Average_Temp > 105
														    AND State_Code IN (30 , 29 , 37 , 26 , 18 , 38)

														    -- Question_#5

														    SELECT
														        State_Name , MIN(Average_Temp) AS 'Minimum Temp' , MAX(ABS(Average_Temp)) AS 'Maximum TEMP' , AVG(Average_Temp) AS 'AVG_Temp'
															  , RANK() OVER(order BY avg(Average_Temp) DESC) AS STATE_RANK
															  FROM
															      AQS_Sites aq , Temperature te
															      WHERE
															          te.State_Code = aq.State_Code
																      AND te.County_Code = aq.County_Code
																          AND te.Site_Num = aq.Site_Number
																	  GROUP BY
																	      State_Name

																	      -- Question_#6

																	      SELECT DISTINCT
																	          State_Code
																		  FROM
																		      aqs_sites
																		      WHERE
																		          State_Name IN ('Canada' ,'Country Of Mexico' ,'Guam' ,'Virgin Islands' ,'Puerto Rico' ,'Hawaii')
																			  /* 15,66,72,78,80,CC
																			   * */
																			   DELETE
																			   FROM
																			       aqs_sites
																			       WHERE
																			           State_Name IN ('15' ,'66' ,'72' ,'78' ,'80' ,'CC')
																				   DELETE
																				   FROM
																				       Temperature
																				       WHERE
																				           State_Code IN ('15' ,'66' ,'72' ,'78' ,'80' ,'CC')
																					       
																					       -- Question_#7 
																					       --  Running
																					       --  before
																					       --  Index 
																					           
																						   	PRINT 'Begin Q 2 before Index Create At - ' + CONVERT(varchar, SYSDATETIME(), 120) 
																								
																									GO
																									Select
																									    ta.State_Name , MIN(ta.Average_Temp) as 'Minimum Temp' , MAX(ta.Average_Temp) as 'Maximum Temp' , AVG(ta.Average_Temp) as 'Average Temp'
																									    From
																									        (
																										        Select
																											            a.State_Name   , a.State_Code , a.County_Code , a.Site_Number
																												              , t.Average_Temp , t.Daily_High_Temp
																													              From
																														                  Temperature t , AQS_Sites a
																																          Where
																																	              a.State_Code      = t.State_Code
																																		                  and a.County_Code = t.County_Code
																																				              and a.Site_Number = t.Site_Num
																																					          )
																																						      ta
																																						      Group by
																																						          ta.State_Name
																																							  Order by
																																							      ta.State_Name PRINT 'Complete Q 2 before Index Create At - ' + CONVERT(varchar, SYSDATETIME(), 120)

																																							      -- Creating
																																							      -- Index
																																							      CREATE INDEX idx_AvgTemp
																																							      ON
																																							          Temperature
																																								      (
																																								              Average_Temp
																																									          )
																																										      WITH
																																										          (
																																											          DROP_EXISTING = ON
																																												      )
																																												      ;

																																												      CREATE INDEX idx_DailyHighTemp
																																												      ON
																																												          Temperature
																																													      (
																																													              Daily_High_Temp
																																														          )
																																															      WITH
																																															          (
																																																          DROP_EXISTING = ON
																																																	      )
																																																	      ;

																																																	      CREATE INDEX idx_date
																																																	      ON
																																																	          Temperature
																																																		      (
																																																		              Date_Local
																																																			          )
																																																				      WITH
																																																				          (
																																																					          DROP_EXISTING = ON
																																																						      )
																																																						      ;

																																																						      CREATE INDEX idx_primarykeys
																																																						      on
																																																						          Temperature
																																																							      (
																																																							              State_Code , County_Code , Site_Num
																																																								          )
																																																									      WITH
																																																									          (
																																																										          DROP_EXISTING = ON
																																																											      )
																																																											      ;

																																																											      CREATE INDEX idx_primarykeys_aqs_sites
																																																											      on
																																																											          AQS_Sites
																																																												      (
																																																												              State_Code , County_Code , Site_Number
																																																													          )
																																																														      WITH
																																																														          (
																																																															          DROP_EXISTING = ON
																																																																      )
																																																																      ;

																																																																      /* Running
																																																																       * after
																																																																       * Index
																																																																       * creation
																																																																       * */
																																																																       Print 'Begin Q 2 after Index Create At - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))
																																																																       Select
																																																																           ta.State_Name , MIN(ta.Average_Temp) as 'Minimum Temp' , MAX(ta.Average_Temp) as 'Maximum Temp' , AVG(ta.Average_Temp) as 'Average Temp'
																																																																	   From
																																																																	       (
																																																																	               Select
																																																																		                   a.State_Name   , a.State_Code , a.County_Code , a.Site_Number
																																																																				             , t.Average_Temp , t.Daily_High_Temp
																																																																					             From
																																																																						                 Temperature t , AQS_Sites a
																																																																								         Where
																																																																									             a.State_Code      = t.State_Code
																																																																										                 and a.County_Code = t.County_Code
																																																																												             and a.Site_Number = t.Site_Num
																																																																													         )
																																																																														     ta
																																																																														     Group by
																																																																														         ta.State_Name
																																																																															 Order by
																																																																															     ta.State_Name Print 'Complete Q 2 after Index Create At - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))

																																																																															     -- Question_#8

																																																																															     with ranktable as
																																																																															         (
																																																																																         select T.State_Code, T.State_rank , Temperature.County_Code , Temperature.Site_Num, avg(Temperature.Average_Temp) as avg_temperature , dense_rank() over( partition by T.state_rank order by avg(Temperature.average_temp) desc) as State_city_rank
																																																																																	         from
																																																																																		             Temperature , (
																																																																																			                     select
																																																																																					                         top 15 State_code , avg(Average_temp) as avg_temp , DENSE_RANK() over( order by avg(Average_temp) desc) as State_rank
																																																																																								                 from
																																																																																										                     Temperature
																																																																																												                     where
																																																																																														                         state_code <= 56
																																																																																																	                 group by
																																																																																																			                     state_code
																																																																																																					                 )
																																																																																																							             T
																																																																																																								             where
																																																																																																									                 Temperature.State_Code = T.State_Code
																																																																																																											         group by
																																																																																																												             Site_Num , County_Code , T.state_code , T.state_rank
																																																																																																													         )
																																																																																																														 select distinct
																																																																																																														     ranktable.State_rank , aqs_sites.State_Name , ranktable.State_city_rank , aqs_sites.City_Name
																																																																																																														       , ranktable.avg_temperature
																																																																																																														       from
																																																																																																														           ranktable
																																																																																																															       left join
																																																																																																															               aqs_sites
																																																																																																																               on
																																																																																																																	                   ranktable.State_Code      = aqs_sites.State_Code
																																																																																																																			               and ranktable.County_Code = aqs_sites.County_Code
																																																																																																																				                   and ranktable.Site_Num    = aqs_sites.Site_Number
																																																																																																																						   order by
																																																																																																																						       State_rank , State_city_rank

																																																																																																																						       --Question_#9

																																																																																																																						          If OBJECT_ID(N'dbo.[NotCity]',N'V') is not null begin drop view NotCity
																																																																																																																							  end 

																																																																																																																							  go
																																																																																																																							      CREATE VIEW NotCity as
																																																																																																																							          (
																																																																																																																								          select
																																																																																																																									              County_Code+','+Site_Number as CScode
																																																																																																																										              from
																																																																																																																											                  aqs_sites
																																																																																																																													          where
																																																																																																																														              city_name like '%not in a city%'
																																																																																																																															          )
																																																																																																																																  ;

																																																																																																																																  --Question_#10

																																																																																																																																  with ranktable as
																																																																																																																																      (
																																																																																																																																              select
																																																																																																																																	                  T.State_Code, T.State_rank , Temperature.County_Code , Temperature.Site_Num , avg(Temperature.Average_Temp) as avg_temperature , DENSE_RANK() over ( partition by T.state_rank order by avg(Temperature.average_temp) desc) as State_city_rank
																																																																																																																																			          from
																																																																																																																																				              Temperature , (
																																																																																																																																					                      select
																																																																																																																																							                          top 15 State_code , avg(Average_temp) as avg_temp , DENSE_RANK() over( order by avg(Average_temp) desc) as State_rank
																																																																																																																																										                  from
																																																																																																																																												                      Temperature
																																																																																																																																														                      where
																																																																																																																																																                          state_code <= 56
																																																																																																																																																			                  group by
																																																																																																																																																					                      state_code
																																																																																																																																																							                  )
																																																																																																																																																									              T
																																																																																																																																																										              where
																																																																																																																																																											                  Temperature.State_Code = T.State_Code
																																																																																																																																																													              and
																																																																																																																																																														                  (
																																																																																																																																																																                  Temperature.County_Code+','+Temperature.Site_Num
																																																																																																																																																																		              )
																																																																																																																																																																			                  not in
																																																																																																																																																																					              (
																																																																																																																																																																						                      select
																																																																																																																																																																								                          CScode
																																																																																																																																																																											                  from
																																																																																																																																																																													                      NotCity
																																																																																																																																																																															                  )
																																																																																																																																																																																	          group by
																																																																																																																																																																																		              Site_Num , County_Code , T.state_code , T.state_rank
																																																																																																																																																																																			          )
																																																																																																																																																																																				  select distinct
																																																																																																																																																																																				      ranktable.State_rank , aqs_sites.State_Name , ranktable.State_city_rank , aqs_sites.City_Name
																																																																																																																																																																																				        , ranktable.avg_temperature
																																																																																																																																																																																					from
																																																																																																																																																																																					    ranktable
																																																																																																																																																																																					        left join
																																																																																																																																																																																						        aqs_sites
																																																																																																																																																																																							        on
																																																																																																																																																																																								            ranktable.State_Code      = aqs_sites.State_Code
																																																																																																																																																																																									                and ranktable.County_Code = aqs_sites.County_Code
																																																																																																																																																																																											            and ranktable.Site_Num    = aqs_sites.Site_Number
																																																																																																																																																																																												    where
																																																																																																																																																																																												        State_city_rank <= 2
																																																																																																																																																																																													group by
																																																																																																																																																																																													    State_rank , State_city_rank , State_Name , City_Name
																																																																																																																																																																																													      , avg_temperature
																																																																																																																																																																																													      order by
																																																																																																																																																																																													          State_rank , State_city_rank

																																																																																																																																																																																														  -- Question_#11 

																																																																																																																																																																																														  Select
																																																																																																																																																																																														      a.City_Name , DATEPART(MONTH,Date_Local) as Month , COUNT(*) as '# of Records', AVG(t.Average_Temp) as Average_Temp
																																																																																																																																																																																														      From
																																																																																																																																																																																														          Temperature t , AQS_Sites a
																																																																																																																																																																																															  Where
																																																																																																																																																																																															      a.State_Code      = t.State_Code
																																																																																																																																																																																															          and a.County_Code = t.County_Code
																																																																																																																																																																																																      and a.Site_Number = t.Site_Num
																																																																																																																																																																																																          and a.City_Name  IN ( 'Mission','Pinellas Park' , 'Tucson'  , 'Ludlow')
																																																																																																																																																																																																	      and a.State_Name IN ( 'Texas' ,'Florida'   , 'Arizona' , 'California')
																																																																																																																																																																																																	      Group by
																																																																																																																																																																																																	          a.City_Name , DATEPART(MONTH,Date_Local)
																																																																																																																																																																																																		  Order by
																																																																																																																																																																																																		      a.City_Name , DATEPART(MONTH,Date_Local)

																																																																																																																																																																																																		      --Question_#12

																																																																																																																																																																																																		      Select *
																																																																																																																																																																																																		      From
																																																																																																																																																																																																		          (
																																																																																																																																																																																																			          Select distinct
																																																																																																																																																																																																				              a.City_Name , t.Average_Temp , CUME_DIST() Over (
																																																																																																																																																																																																					                                                               Partition by a.City_Name
																																																																																																																																																																																																												                                                                Order by
																																																																																																																																																																																																																				                                                             t.Average_Temp) as Temp_Cume_Dist
																																																																																																																																																																																																																											             From
																																																																																																																																																																																																																												                 Temperature t , AQS_Sites a
																																																																																																																																																																																																																														         Where
																																																																																																																																																																																																																															             a.State_Code      = t.State_Code
																																																																																																																																																																																																																																                 and a.County_Code = t.County_Code
																																																																																																																																																																																																																																		             and a.Site_Number = t.Site_Num
																																																																																																																																																																																																																																			                 and a.City_Name  IN ('Pinellas Park' , 'Mission' , 'Tucson')
																																																																																																																																																																																																																																					             and a.State_Name IN ('Florida'       , 'Texas'   , 'Arizona')
																																																																																																																																																																																																																																						         )
																																																																																																																																																																																																																																							     TCum
																																																																																																																																																																																																																																							     Where
																																																																																																																																																																																																																																							         TCum.Temp_Cume_Dist between 0.4 and 0.6

																																																																																																																																																																																																																																								 --Question_#13

																																																																																																																																																																																																																																								 Select DISTINCT
																																																																																																																																																																																																																																								                                                                                                                                                          City_Name, PERCENTILE_DISC(0.4) WITHIN GROUP (ORDER BY AVERAGE_TEMP) OVER (PARTITION BY CITY_NAME) AS '40 PERCENTILE TEMP' , PERCENTILE_DISC(0.6) WITHIN GROUP (ORDER BY AVERAGE_TEMP) OVER (PARTITION BY CITY_NAME) AS '60 PERCENTILE TEMP'
																																																																																																																																																																																																																																																											  from
																																																																																																																																																																																																																																																											      AQS_Sites A , Temperature T
																																																																																																																																																																																																																																																											      WHERE
																																																																																																																																																																																																																																																											          City_Name IN ('Pinellas Park' , 'Mission' , 'Tucson')
																																																																																																																																																																																																																																																												      AND A.County_Code=T.County_Code
																																																																																																																																																																																																																																																												          AND A.State_Code =T.State_Code
																																																																																																																																																																																																																																																													      AND A.Site_Number=T.Site_Num
																																																																																																																																																																																																																																																													      ORDER BY
																																																																																																																																																																																																																																																													          City_Name

																																																																																																																																																																																																																																																														  --Question_#14

																																																																																																																																																																																																																																																														  Select
																																																																																																																																																																																																																																																														      tt.City_Name , tt.Percentile , MIN(tt.Average_Temp) as MIN_Temp , MAX(tt.Average_Temp) as MAX_Temp
																																																																																																																																																																																																																																																														      From
																																																																																																																																																																																																																																																														          (
																																																																																																																																																																																																																																																															          Select
																																																																																																																																																																																																																																																																              a.City_Name , t.Average_Temp , NTILE(10) Over(Partition by a.City_Name Order by t.Average_Temp) as Percentile
																																																																																																																																																																																																																																																																	              From
																																																																																																																																																																																																																																																																		                  Temperature t , AQS_Sites a
																																																																																																																																																																																																																																																																				          Where
																																																																																																																																																																																																																																																																					              a.State_Code      = t.State_Code
																																																																																																																																																																																																																																																																						                  and a.County_Code = t.County_Code
																																																																																																																																																																																																																																																																								              and a.Site_Number = t.Site_Num
																																																																																																																																																																																																																																																																									                  and a.City_Name  IN ('Pinellas Park' , 'Mission' , 'Tucson')
																																																																																																																																																																																																																																																																											              and a.State_Name IN ('Florida'       , 'Texas'   , 'Arizona')
																																																																																																																																																																																																																																																																												          )
																																																																																																																																																																																																																																																																													      tt
																																																																																																																																																																																																																																																																													      Group by
																																																																																																																																																																																																																																																																													          tt.City_Name , tt.Percentile

																																																																																																																																																																																																																																																																														  --Question_#15

																																																																																																																																																																																																																																																																														  Select
																																																																																																																																																																																																																																																																														      tt.City_Name , tt.Average_Temp , FORMAT(PERCENT_RANK() Over ( Partition by tt.City_Name Order by tt.Average_Temp), 'P') as 'Percentage'
																																																																																																																																																																																																																																																																														      From
																																																																																																																																																																																																																																																																														          (
																																																																																																																																																																																																																																																																															          Select distinct
																																																																																																																																																																																																																																																																																              a.City_Name , CAST(t.Average_Temp as INT) as Average_Temp
																																																																																																																																																																																																																																																																																	              From
																																																																																																																																																																																																																																																																																		                  Temperature t , AQS_Sites a
																																																																																																																																																																																																																																																																																				          Where
																																																																																																																																																																																																																																																																																					              a.State_Code      = t.State_Code
																																																																																																																																																																																																																																																																																						                  and a.County_Code = t.County_Code
																																																																																																																																																																																																																																																																																								              and a.Site_Number = t.Site_Num
																																																																																																																																																																																																																																																																																									                  and a.City_Name  IN ('Pinellas Park' , 'Mission' , 'Tucson')
																																																																																																																																																																																																																																																																																											              and a.State_Name IN ('Florida'       , 'Texas'   , 'Arizona')
																																																																																																																																																																																																																																																																																												          )
																																																																																																																																																																																																																																																																																													      tt

																																																																																																																																																																																																																																																																																													      --Question_#16

																																																																																																																																																																																																																																																																																													      Select
																																																																																																																																																																																																																																																																																													          TDay.City_Name , TDay.[Day of the Year] , AVG(TDay.Average_Temp) Over (Partition by TDay.City_Name Order by TDay.[Day of the Year] asc ROWS BETWEEN 3 Preceding AND 1 following) as Rolling_Avg_Temp
																																																																																																																																																																																																																																																																																														  From
																																																																																																																																																																																																																																																																																														      (
																																																																																																																																																																																																																																																																																														              Select distinct
																																																																																																																																																																																																																																																																																															                  a.City_Name , DATEPART(DY, t.Date_Local) as 'Day of the Year' , AVG(t.Average_Temp) as Average_Temp
																																																																																																																																																																																																																																																																																																	          From
																																																																																																																																																																																																																																																																																																		              Temperature t , AQS_Sites a
																																																																																																																																																																																																																																																																																																			              Where
																																																																																																																																																																																																																																																																																																				                  a.State_Code      = t.State_Code
																																																																																																																																																																																																																																																																																																						              and a.County_Code = t.County_Code
																																																																																																																																																																																																																																																																																																							                  and a.Site_Number = t.Site_Num
																																																																																																																																																																																																																																																																																																									              and a.City_Name  IN ('Pinellas Park' , 'Mission' , 'Tucson')
																																																																																																																																																																																																																																																																																																										                  and a.State_Name IN ('Florida'       , 'Texas'   , 'Arizona')
																																																																																																																																																																																																																																																																																																												          Group by
																																																																																																																																																																																																																																																																																																													              a.City_Name , DATEPART(DY,t.Date_Local)
																																																																																																																																																																																																																																																																																																														          )
																																																																																																																																																																																																																																																																																																															      TDay 	
																																																																																																																																																																																																																																																																																																															      ;
