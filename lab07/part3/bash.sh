#!/bin/bash
> output.txt
echo "Algorithm 1" >> output.txt
for i in 256, 512, 768, 1024, 1280, 1536, 1792, 2048
do
	./matrix_math 1 $i | grep 'Floating-point ops/sec:' | cut -f2 -d":" | cat >> output.txt
done
echo "Algorithm 2" >> output.txt
for i in 256, 512, 768, 1024, 1280, 1536, 1792, 2048
do
	./matrix_math 2 $i | grep 'Floating-point ops/sec:' | cut -f2 -d":" >> output.txt 
done
