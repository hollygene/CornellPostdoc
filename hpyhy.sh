# Hyphy tutorial from Jordan

# can install using conda environment
# available from Github
# dev branch of github has newer features that aren't on datamonkey

# to install hyphy with conda
# set up virtual env first with conda
# good for knowing what version you're running

conda install hyphy


git clone *hyphy github repo
git clone hyphy develop repo

# git checkout latest hyphy
# can specify version here
git checkout origin/develop

cmake -DNQAVX=ON
make -j MP
make -j MPI

[HYPHYMP] LIBPATH=[LIBPATH] [BUSTED] <args>
hyphy_develop/hyphy

# to run in parallel
mpirun -np 8
[HYPHYMPI] LIBPATH=[LIBPATH] [BUSTED] <args>



## partition - refers to GARD fragment (non-recombinant fragment)
#
