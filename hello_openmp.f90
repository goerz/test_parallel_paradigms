program hello_openmp

  USE omp_lib
  implicit none


  integer :: i

  write(*,'("Max number of OMP Threads:",I0)') omp_get_max_threads()

  !$omp parallel do default(shared) private(i)
  do i = 1, 100
    write(*,'("loop index ",I2,", thread ",I2," / ",I2)') &
    &    i, omp_get_thread_num()+1, omp_get_num_threads()
  end do
  !$omp end parallel do

end program hello_openmp
