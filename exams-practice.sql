SELECT Month,
       City,
       Agency,
       SUM(numberOfMeasurements),
       SUM(numberOfMeasurements) / SUM(SUM(numberOfMeasurements)) OVER (),
       SUM(numberOfMeasurements) /
       MAX(SUM(numberOfMeasurements)) OVER (PARTITION BY Month, Region)

FROM Sensor S,
     Date D,
     Agency A,
     Measurement M

WHERE S.sensorId = M.sensorId
  AND D.dateId = M.dateId
  and A.agencyId = M.agencyId
  AND Year = 2020

GROUP BY Month, City, Agency, Region

-- SECOND

SELECT City,
       Month,

       SUM(numberOfMeasurements),

       100 * SUM(numberOfMeasurements) /
       SUM(SUM(numberOfMeasurements)) OVER (PARTITION BY Region, Month),
       RANK() OVER (PARTITION BY Month ORDER BY SUM(numberOfMeasurements) DESC),

       AVG(SUM(numberOfMeasurements)) OVER
           (PARTITION BY City
           ORDER BY Month
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)

FROM Sensor S,
     Date D,
     Measurement M


WHERE S.sensorId = M.sensorId
  AND D.dateId = M.dateId
  AND Year = 2020

-- THIRD
create or replace trigger SCHEDULE_THE_VISIT
after insert on VISIT_REQUEST

for each row

declare

N, NV, myVet number;

begin



if (:new.VetCode is not null) then

--- check if the requested veterinarian is on shift

	select count(*) into N

	from VETERINARY_SHIFTS

	where VetCode = :new.VetCode and Date = :new.Date;



	if (N = 0) then

--- the vet is not on duty

		raise_application_ error(..);

	else

		myVet := :new.VetCode;

	endif;

else

--- the veterinarian is not specified

	select min(NumberOfBookedVisits) into NV

	from VETERINARY_SHIFTS

	where Date = :new.Date;



	if (NV is not null) then

--- al least one veterinarian on shift

--- 	select the veterinarian with the lowest number of booked visits on the requested date

		select VetCode into myVet

		from VETERINARY_SHIFTS

		where NumberOfBookedVisits = NV and Date = :new.Date;

	else

--- no veterinarian available

		raise_application_ error(..);

	endif;

endif;



--- schedule the visit

insert into VISIT_SCHEDULING(....)

values (:new.RequestCode, myVet, :new.Date, :new.CustomerSSN);

end;

--- FOURTH
create trigger MaxVisits
after insert or update of CustomerSSN, Date on VISIT_REQUEST

declare

X number;



begin

select count(*) into X

from VISIT_REQUEST

where CustomerSSN in

  (select CustomerSSN

   from VISIT_REQUEST

   group by CustomerSSN, Date

   having count(*) > 1);



if (X <> 0) then

   raise_application_error(...)

end if;

end;





