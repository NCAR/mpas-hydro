# MPAS-Hydro
MPAS-Hydro is a coupling of the [MPAS](https://github.com/MPAS-Dev/MPAS-Model) Atmosphere and [WRF-Hydro](https://github.com/NCAR/wrf_hydro_nwm_public).
The coupling mechanism uses [Earth System Modeling Framework](https://earthsystemmodeling.org/)
(ESMF) and the [National Unified Operational Prediction Capability](https://earthsystemmodeling.org/nuopc)
(NUOPC) interoperability layer, also reffered to as a cap.



## Build
MPAS-Hydro couples using the ESMX infrastructure.
Note, the build instructions are specific to Derecho at the current moment.

### Dependencies
- MPI
- Fortran NetCDF
- ParallelIO
- ESMF
- OpenBLAS
- CMake

#### Derecho Modules
Load appropriate set of modules, the following are for building with GNU.
```
$ ml purge
$ ml ncarenv/24.12 gcc/12.4.0 ncarcompilers cray-mpich cmake openblas parallelio
$ ml esmf/8.8.1 netcdf-mpi/4.9.3 parallel-netcdf hdf5-mpi
```


### Retrieve Code
```
Retrieve repository
$ git clone --branch mpas-hydro --recurse-submodules git@github.com:NCAR/mpas-hydro.git
$ cd mpas-model
```


### Build Instructions
```
$ AUTOCLEAN=true \
  PIO=${NCAR_ROOT_PARALLELIO} \
  PnetCDF_ROOT=${NCAR_ROOT_PARALLEL_NETCDF} \
  PnetCDF_MODULE_DIR=${NCAR_ROOT_PARALLEL_NETCDF}/include \
  USE_MPI_F08=0 \
  MPAS_HYDRO=true \
  ESMX_Builder -v --build-jobs=4 --build-type=Debug
```

The user can also use the provided `Makefile` in the top directory.
```
$ make
or
$ make build
```




## Run Instructions
Setup a case, one could download a [MPAS testcase](https://www2.mmm.ucar.edu/projects/mpas/test_cases/v7.0/).
Make sure that `esmxRun.yaml, init_atmosphere_model` and `mpas_hydro` are present in the directory.

```
Run initialization executable
$ ./init_atmosphere_model
Run MPAS Hydro
$ mpirun -np 4 ./mpas_hydro
```

## Visualize Output
### Requirements
- [UXarray](https://uxarray.readthedocs.io/en/latest/)
- [JupyterLab](https://jupyterlab.readthedocs.io/en/latest/)

```
$ conda create --prefix /path/to/conda_env/uxarray
$ conda activate uxarray
$ conda install -c conda-forge uxarray jupyterlab
```

### Visualization
Start JupyterLab
```
$ jupyter lab
```

Edit a jupyter notebook to have something similar the following
```
import uxarray as ux
uxds_orig = ux.open_dataset("x1.40962.grid.nc", "output.nc")
uxds = uxds_orig.isel(Time=0)
uxds.uxgrid = uxds_orig.uxgrid  # reattach grid after selection for time
uxds['ter'].plot()
```

## NUOPC Cap Exchange
- [ ] Add list of variables being exchanged for two and one way coupling


## Graphs
- [ ] create graphs of procedures, variables exchanged, data structures, process workflow


## Directory Structure
```
mpas-model/
├──src/
│   ├──hydro/
│   │   └──src/CPL/NUOPC_cpl/
│   ├──mpas/
│   │   └──src/
│   │       ├──core_atmosphere/couple/nuopc/
│   │       └──core_init_atmosphere/
│   └──noahmp/
│       ├──drivers/nuopc/
│       └──src/
└──test/
    └──testcases/
```

# Tutorial
## Running Idealized Case
Following instructions from [MPAS Tutorial 2024](https://www2.mmm.ucar.edu/projects/mpas/tutorial/Howard2024/index.html)

<!-- Front Range, CO (70.2 MB) -->

<!-- Setup Testcase -->
<!-- $ wget https://github.com/NCAR/wrf_hydro_nwm_public/releases/download/v5.4.0/front_range_CO_example_testcase_coupled.tar.gz -->
<!-- $ tar zxf front_range_CO_example_testcase_coupled.tar.gz -->
<!-- $ cd example_case_coupled -->

```
JW Baroclinic for now, Front Range, CO in the Future

Setup Testcase
$ wget https://www2.mmm.ucar.edu/projects/mpas/test_cases/v7.0/jw_baroclinic_wave.tar.gz
$ tar zxf jw_baroclinic_wave.tar.gz
$ cd jw_baroclinic_wave/* .


Symlink the executables
$ ln -s ../install/bin/init_atmosphere_model .
$ ln -s ../install/bin/mpas_hydro

Run, choose an np such that the file frontrange.graph.info.part.{np} exists
Note, frontrange is small enough to run in serial, without MPI
$ mpiexec -np 4 ./init_atmosphere_model
$ mpiexec -np 4 ./mpas_hydro
```
