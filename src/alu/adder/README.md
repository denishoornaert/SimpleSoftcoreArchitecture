# Adder component

Simple adder capable of either computing :
 - 32bits by 32bits
 - 16bits by 16bits
 - 8bits by 8bits

In other words, it enables ILP.
The choice of the addition is specified through the `mode` input.

The adder component is itself composed of four 8bits adders that are connected to each other through their carry signals (`in` and `out`).

![alt text](https://github.com/denishoornaert/SimpleSoftcoreArchitecture/blob/alu/images/adder.png)
