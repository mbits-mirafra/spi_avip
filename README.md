# Accelerated VIP for SPI Protocol

The idea of using Accelerated VIP is to push the synthesizable part of the testbench into the separate top module along with the interface and it is named as HDL TOP and the unsynthesizable part is pushed into the HVL TOP. This setup provides the ability to run the longer tests quickly. This particular testbench can be used for the simulation as well as the emulation based on mode of operation.

# Key Features  
1. Supports Full Duplex SPI System 
2. Configurable shift register, basically of multiple of 2 bits (depends on character length).
3. Programmable SPI clock frequency range
4. Programmable character length (multiples of 8 bits)
5. Programmable clock phase (delay or no delay)
6. Programmable clock polarity (high or low)
7. Supports Single Master, Multiple Slaves configuration.
8. Supports Simple SPI mode
9. Configurable shift directions (LSB first or MSB first)
10. Delay of chip select low to posedge of sclk, last edge of sclk to raising edge of cs and chip select assert to deassert.
11. Continuous and discontinuous transfer

# Architecture Diagram  
![spi_avip_tb_architecture](https://user-images.githubusercontent.com/104111334/180639035-878c48a6-59c4-4ee7-b36b-1748be12b93a.png)

# Developers, Welcome
We believe in growing together and if you'd like to contribute, please do check out the contributing guide below:  
https://github.com/mbits-mirafra/spi_avip/blob/main/contribution_guidelines.md 

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

## Technical Document 
https://github.com/mbits-mirafra/spi_avip/blob/main/doc/spi_avip_architectural_document.pdf    

## User Guide  
https://github.com/mbits-mirafra/spi_avip/blob/main/doc/spi_avip_user_guide.pdf  

## Contact Mirafra Team  
alokk@mirafra.com  
vishwanath@mirafra.com  
muneebullashariff@mirafra.com  

