#!/bin/bash
#
# Comment:
#
#   This script installs and runs the fortran program date9999.
#   The program prints a calender within a given range and
#   with a specified increment for monthly and daily data.
#   Valid choices range from year 0 to 9999. Century years
#   would not be leap years unless they were divisible by 400.
#
#
#
#   USAGE:  bash date9999.sh
#
#
#   NOTE: It seems to be reasonable, to copy parts of the
#         program as a subroutine to conversion programs, e.g.
#         from .grads to .srv files.
#
#
#   AUTHOR: Stefan Liess 11Mar2001
#
#
########################################################################
# Specify the installed fortran compiler
FC="gfortran"

cat > date9999.f << EOF
      program date9999
C
      implicit none
      integer*4 l,date,edate,year,month,day,dt,mo,leap

C---5---10--------20--------30--------40--------50--------60--------7072

       write(*,*) 'This program prints a calender within a given range a
     1nd with a specified increment for monthly and daily data.'
       write(*,*) 'Valid choices range from year 0 to 9999. Century year
     1s would not be leap years unless they were divisible by 400.'
       write(*,*) ' '
       write(*,*) 'Enter 1 if you want an index before the data, 0 if not.'
       read(*,*) ind
       write(*,*) ' '
       write(*,*) 'Enter 1 for daily data or 0 for monthly data.'
       read(*,*) mo
         if(mo.eq.1) then
       write(*,*) 'Enter 0 if you want to ignore leap years (e.g. for so
     1me pentad data), 1 if not.'
       read(*,*) leap
       write(*,*) ' '
       write(*,*) 'Enter 1st Date (YYYYMMDD) Number of Days and Incremen
     1t (Days):'
         elseif(mo.eq.0) then
       write(*,*) 'Enter 1st Date (YYYYMMDD) Number of Months and Increm
     1ent (Months):'
         endif
       read(*,*) date,edate,dt
       write(*,*) ' '
       write(*,*) 'Your Choice:'
       write(*,*) 'Date:',date,' Number of Timesteps:',edate,' Increment
     1:',dt 
       write(*,*) ' '

      l=1
      do 111 l=1,edate,dt

         month=mod(date,10000)/100
         year=date/10000
         day=mod(date,100)
c       --> Month even/odd
         if (month.le.7) then
           if (mod(month,2).eq.1) then 
             if (day.gt.31) month=month+1
             day=mod(day-1,31)+1  
c           --> 28 Days in FEB
           elseif (month.eq.2) then
	    if (leap.eq.1) then
             if(mod(year,4).eq.0) then
               if (mod(year,100).eq.0) then
                 if (mod(year,400).eq.0) then
                   if(day.gt.29) month=month+1
                   day=mod(day-1,29)+1
                 else
                   if(day.gt.28) month=month+1
                   day=mod(day-1,28)+1
                 endif
               else 
                 if(day.gt.29) month=month+1
                 day=mod(day-1,29)+1
               endif 
             else
               if(day.gt.28) month=month+1
               day=mod(day-1,28)+1
             endif
	    else
             if(day.gt.28) month=month+1
             day=mod(day-1,28)+1
            endif
           elseif ((mod(month,2).eq.0).and.(month.ne.2)) then 
             if(day.gt.30) month=month+1
             day=mod(day-1,30)+1 
           endif
         else
          if (mod(month,2).eq.1) then 
            if(day.gt.30) month=month+1
            day=mod(day-1,30)+1 
          else
            if(day.gt.31) month=month+1
            day=mod(day-1,31)+1 
          endif
         endif
         if(month.gt.12) year=year+1
         month=mod(month-1,12)+1

         if(mo.eq.1) date=year*10000+month*100+day
         if(mo.eq.0) date=year*10000+month*100+day

         if (ind.eq.1) write(*,*) l, ' ', date
         if (ind.eq.0) write(*,*) date
         if(mo.eq.1) date=date+dt
         if(mo.eq.0) date=date+(dt*100)

 111  enddo

      stop
      end

EOF

  if [ ! -f date9999 ]
  then
    echo 'compiling program'
    $FC -o date9999 date9999.f
    rm -f date9999.f
    echo 'compiling done'
  fi
  ./date9999
exit
