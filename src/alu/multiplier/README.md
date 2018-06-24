# Multiplier component

Simple multiplier capable of either computing :
 - 32bits by 32bits
 - 16bits by 16bits
 - 8bits by 8bits

In other words, it enables ILP.
The choice of the multiplication is specified through the `mode` input.

## TODOs
 - [ ] implement and manage properly the carry flags
 - [ ] implement a more optimized way (in term of area) to multiply

![alt text](https://github.com/denishoornaert/SimpleSoftcoreArchitecture/blob/alu/images/multiplier.png)
