# Accelerated Verification IP for SPI Protocol

The whole idea of using Accelerated VIP is to push the synthesizable part of the testbench into the separate top module along with the interface and it is named as HDL TOP. and the unsynthesizable part is pushed into the HVL TOP it provides the ability to run the longer tests quickly. This particular testbench can be used for the simulation as well as the emulation based on mode of operation.


# Developers, Welcome
For source code browsing, we recommend using the fully-indexed and searchable mirror at https://cs.opensource.google/verible/verible.  

If you'd like to contribute, check out the contributing guide and the development resources.  

# Installation - Get the VIP collateral from the GitHub repository

```
# Checking for git software, open the terminal type the command
git version

# Get the VIP collateral
git clone git@github.com:mbits-mirafra/spi_avip.git
```

# Running the test

### Using Mentor's Questasim simulator 

```
cd spi_avip/sim/questasim

# Compilation:  
make compile

# Simulation:
make simulate test=<test_name> uvm_verbosity=<VERBOSITY_LEVEL>

ex: make simulate test=spi_simple_fd_8b_test uvm_verbosity=UVM_HIGH

# Note: You can find all the test case names in the path given below   
spi_avip/src/hvl_top/testlists/spi_simple_fd_regression.list

# Wavefrom:  
vsim -view <test_name>/waveform.wlf &

ex: vsim -view spi_simple_fd_8b_test/waveform.wlf &

# Regression:
make regression testlist_name=<regression_testlist_name.list>
ex: make regression testlist_name=spi_simple_fd_regression.list

# Coverage: 
 ## Individual test:
 firefox <test_name>/html_cov_report/index.html &
 ex: firefox spi_simple_fd_8b_test/html_cov_report/index.html &

 ## Regression:
 firefox merged_cov_html_report/index.html &

```

### Using Cadence's Xcelium simulator 

```
cd spi_avip/sim/cadence_sim

# Compilation:  
make compile

# Simulation:
make simulate test=<test_name> uvm_verbosity=<VERBOSITY_LEVEL>

ex: make simulate test=spi_simple_fd_8b_test uvm_verbosity=UVM_HIGH

# Note: You can find all the test case names in the path given below   
spi_avip/src/hvl_top/testlists/spi_simple_fd_regression.list

# Wavefrom:  
simvision waves.shm/ &

# Regression:
make regression testlist_name=<regression_testlist_name.list>
ex: make regression testlist_name=spi_simple_fd_regression.list

# Coverage:   
imc -load cov_work/scope/test/ &
```



![Fig 2 1 spi_avip_tb_architecture drawio](https://user-images.githubusercontent.com/104111334/165571701-3ed92657-d80c-44d9-8e5a-e622436ba047)

## Architectural Document 
https://docs.google.com/document/d/e/2PACX-1vS4DnKb5akCCC_zODun8u6wgevKRXrBYgc44t6a4oQnUtdy2bDF_CfOGEXV9rsc6gddOoZ2uJYJHnrI/pub

## User Guide to start using the project 
https://docs.google.com/document/d/e/2PACX-1vTGXJSuW7pp7cO2nlFyMgjifRK2dPp5kX11YQ_JrvLsQZLpZvcdBv6Oy6OQ7WH_vvCJ3RXf-XzD4rTE/pub
