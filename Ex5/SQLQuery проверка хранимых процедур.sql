-- Добавление нового клиента
EXEC AddNewClient 
    @FirstName = 'Сергей',
    @LastName = 'Сергеев',
    @DateOfBirth = '1980-04-15',
    @Gender = 'Мужской',
    @ContactPhone = '777-777',
    @Health = 'Отличное',
	@Middle_Name = 'Сергеевич';

-- Добавление нового тренера
EXEC AddNewTrainer 
	@FirstName = 'Алексей',		
	@LastName = 'Алексеев', 
	@Experience = 3, 
	@ContactPhone = '999-999',
	@AddressID = 1, 
	@Passport = '987654321';


--Подсчет общего количества занятий, проведенных тренером
DECLARE @TotalClasses int;
EXEC CountTotalClassesByTrainer 
	@TrainerID = 1, 
	@TotalClasses = @TotalClasses 
OUTPUT;
SELECT 'Общее количество занятий тренера с ID 1: ' + CAST(@TotalClasses AS varchar(10)) AS TotalClasses;

--Регистрация клиента на занятие
EXEC RegisterClientToSchedule 
    @ClientID = 1,
    @ScheduleID = 2;

-- Отмена занятия
EXEC CancelRegister
	@ScheduleID = 1;


-- Обновление информации о тренере
EXEC UpdateTrainerInfo 
	@TrainerID = 1, 
	@Experience = 6, 
	@ContactPhone = '888-888';