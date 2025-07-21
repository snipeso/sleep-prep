function C = pseudo_lzc(array)


[Starts, Ends] = sprep.utils.data2windows(array>0);

C = std(Ends-Starts);