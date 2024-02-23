# ExtendableStruct.jl
Extendable data structure pattern. 
So we only load the NEW data on a custom dimension and reuse the previously cached data. 

Using this PKG. The best data management I believe is here: CachPersExteInitLoadableStruct.jl

*extendable* data structure. It supports merge(concatenate) operation to merge them to each other. 

*Use this with:* [UltimateStruct.jl](https://github.com/Cvikli/UniversalStruct.jl)

## To use:
So if you have an `obj`, that points to a hugh dataset or smaller dataset than `c_obj`(cached_object). Then if you write:
```julia
extend!(obj::T,c_obj::T)
```
It will use the `c_obj` already valid data and `load_data!` only the new necessary data.

To make it work overload these functions: 
```julia
# Concat two data with same config.
append(before::T, after::T)      where T <: Extendable = throw("Implement the merging process, how do you concat two $T")

# Do we need new data (in front/after) of our current data?
need_data_before(obj::T, c::T)   where T <: Extendable = obj.fr < c.fr
need_data_after(obj::T,  c::T)   where T <: Extendable = c.to < obj.to

# Configure and init the (before/after) object that is able to download the right data with load_data
init_before_data(obj::T, c::T)   where T <: Extendable = init(T, obj.fr, c.fr, obj.config)
init_after_data(obj::T,  c::T)   where T <: Extendable = init(T, c.to, obj.to, obj.config)
```

## Example
If you are storing queries... so you request the data from TimeStamp to Timestamp. And on new interval you don't just redownload the whole datasize. You just download the "new" data and *extend* the currently cached data. 


## Note
It is really adviced to use this package with https://github.com/Cvikli/MemoizeTyped.jl 
So you can use the `load` function without reloading the data multiple times, so just reuse from cache. 

I am still trying to figure out what is the best pattern to do this that match for everyone usecase. It is not 100% trivial. So maybe there should be multiple way to do it later on. 

Contributions and tips are welcomed! 





