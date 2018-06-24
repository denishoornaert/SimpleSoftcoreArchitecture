# Subtractor component

Simple subtractor capable of either computing :
 - 32bits by 32bits
 - 16bits by 16bits
 - 8bits by 8bits

In other words, it enables ILP.
The choice of the subtraction is specified through the `mode` input.

The subtractor component is itself composed of a 32bits adder that receives the `operand1` and the c2 version of the `operand2`.

![alt text](https://github.com/denishoornaert/SimpleSoftcoreArchitecture/blob/alu/images/subtractor.png)
