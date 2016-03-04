program hello_hybrid

  USE omp_lib
  implicit none

  ! Include the MPI library definitons:
  include 'mpif.h'

  integer :: numtasks, rank, ierr, rc, len, i
  character(MPI_MAX_PROCESSOR_NAME) :: name

  ! Initialize the MPI library:
  call MPI_INIT(ierr)
  if (ierr .ne. MPI_SUCCESS) then
     print *,'Error starting MPI program. Terminating.'
     call MPI_ABORT(MPI_COMM_WORLD, rc, ierr)
  end if

  ! Get the number of processors this job is using:
  call MPI_COMM_SIZE(MPI_COMM_WORLD, numtasks, ierr)

  ! Get the rank of the processor this thread is running on.  (Each
  ! processor has a unique rank.)
  call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)

  ! Get the name of this processor (usually the hostname)
  call MPI_GET_PROCESSOR_NAME(name, len, ierr)
  if (ierr .ne. MPI_SUCCESS) then
     print *,'Error getting processor name. Terminating.'
     call MPI_ABORT(MPI_COMM_WORLD, rc, ierr)
  end if

  if (rank == 0) then
    write(*,'("Max number of OMP Threads:",I0)') omp_get_max_threads()
  end if

  !$omp parallel do default(shared) private(i)
  do i = 1, 40
    write(*,'("Hostname: ",A,", Task ",I2," / ",I2,"; loop index ",I2,", thread ",I2," / ",I2)') &
    &    trim(name), rank+1, numtasks, i, omp_get_thread_num()+1, omp_get_num_threads()
  end do
  !$omp end parallel do

  ! Tell the MPI library to release all resources it is using:
  call MPI_FINALIZE(ierr)

end program hello_hybrid
