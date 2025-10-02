np=4

.PHONY: build

all: build

build:
	AUTOCLEAN=true \
	PIO=${NCAR_ROOT_PARALLELIO} \
	PnetCDF_ROOT=${NCAR_ROOT_PARALLEL_NETCDF} \
	PnetCDF_MODULE_DIR=${NCAR_ROOT_PARALLEL_NETCDF}/include \
	USE_MPI_F08=0 \
	MPAS_HYDRO=true \
	ESMF_RUNTIME_TRACE=ON \
	ESMX_Builder --verbose --build-jobs=$(np) --build-type=Release

clean:
	rm -rf build/ install/*
