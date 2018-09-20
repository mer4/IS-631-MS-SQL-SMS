/* Create and populate a column called  NJITID_Total_Salary and populate it
  with the sum of all salaries for 
 each player. Next, write a trigger that updates the NJITID_ Total_Salary attribute you created in the master 
 table whenever there is a new row added to the salary table or whenever a salary is updated. The trigger name 
 must start with your NJITID and the DDL that creates the trigger must also check to see if the trigger exists 
 before creating it.
 Note: You’ll need to use the old and new salary rows in your trigger to adjust the total correctly.
 Your answer must also include the queries necessary to verify your trigger works correctly. This would 
 typically include a 2 sets of queries. The first set of queries displays the effected columns before the 
 update, inserts a new row in the salary table for the target player, and then redisplays the effected 
 rows/columns after the insert completes. 
 The second set of queries follows the same logic, except the middle query would update an existing row instead 
 of creating a new row. 
 */

 IF NOT EXISTS 
 	(SELECT * 
		FROM INFORMATION_SCHEMA.COLUMNS 
			WHERE TABLE_NAME = 'Master' AND COLUMN_NAME = 'MER4_Total_Salary') 
			BEGIN
				ALTER TABLE Master
					ADD MER4_Total_Salary money;
					END
					GO

					UPDATE Master
						SET MER4_Total_Salary = Total.Tt_Salary FROM 
							(SELECT playerID, SUM(salary) AS Tt_Salary 
								FROM Salaries 
									GROUP BY playerID) AS Total, Master 
										WHERE Total.playerID = Master.playerID 
										GO

										CREATE TRIGGER MER4_TtSalary 
											ON Salaries AFTER INSERT, UPDATE, DELETE 
												AS 
												BEGIN 
													IF EXISTS 
														(SELECT * FROM Inserted) 
															AND EXISTS 
																(SELECT * FROM Deleted) 
																	BEGIN 
																	   		UPDATE Master 
																					SET MER4_Total_Salary = (MER4_Total_Salary - D.salary + I.salary) 
																								FROM Deleted D, Inserted I 
																											WHERE Master.playerID = D.playerID AND Master.playerID = I.playerID 
																												END 
																													IF EXISTS 
																														(SELECT * FROM Inserted) 
																															AND NOT EXISTS 
																																(SELECT * FROM Deleted) 
																																	BEGIN 
																																			UPDATE Master 
																																					SET MER4_Total_Salary = (MER4_Total_Salary + I.salary) 
																																								FROM Inserted I 
																																											WHERE Master.playerID = I.playerID 
																																												END 
																																													IF NOT EXISTS 
																																														(SELECT * FROM Inserted) 
																																															AND EXISTS 
																																																(SELECT * FROM Deleted) 
																																																	BEGIN 
																																																			UPDATE Master 
																																																					SET MER4_Total_Salary = (MER4_Total_Salary - D.salary) 
																																																								FROM Deleted D 
																																																											WHERE Master.playerID = D.playerID 
																																																												END 
																																																												END 
																																																												GO 

																																																												SELECT playerID, MER4_Total_Salary FROM Master WHERE playerID = 'aardsda01'

																																																												SELECT * FROM Salaries WHERE playerID = 'aardsda01'

																																																												SELECT playerID, MER4_Total_Salary FROM Master WHERE playerID = 'aardsda01'
																																																												DELETE FROM Salaries WHERE playerID = 'aardsda01' AND yearID = 2010
																																																												SELECT playerID, MER4_Total_Salary FROM Master WHERE playerID = 'aardsda01'

																																																												SELECT playerID, MER4_Total_Salary FROM Master WHERE playerID = 'aardsda01'
																																																												UPDATE Salaries 
																																																													SET salary = 2000000 WHERE playerID = 'aardsda01' AND yearID = 2011
																																																													SELECT playerID, MER4_Total_Salary FROM Master WHERE playerID = 'aardsda01'

																																																													SELECT playerID, MER4_Total_Salary FROM Master WHERE playerID = 'aardsda01'
																																																													INSERT INTO Salaries VALUES ('2009', 'ATL', 'NL', 'aardsda01', '1000')
																																																													SELECT playerID, MER4_Total_Salary FROM Master WHERE playerID = 'aardsda01'

