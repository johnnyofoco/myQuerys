SELECT userid, procname, filename_, fieldname, oldvalue, newvalue, date_, 
       time_, recordid, recordid2, user1, user2, user3, user4, memopointer, 
       delpointer, type_, computername, deletedfilename, primafield, 
       oldmemo, newmemo, codempr
  FROM actlog.actlog_2020_emp_000374 where primafield like '%JESSICA APARECIDA DE SOUZA HEIRAS%'
