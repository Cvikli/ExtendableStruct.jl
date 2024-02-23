module ExtendableStruct

using InitLoadableStruct: InitableLoadable

export extend!

abstract type Extendable <: InitableLoadable end

######## Core functions
extend!(obj::T,c_obj::T)                        where T <: Extendable = merge(data_before(obj, c_obj), c_obj, data_after(c_obj, obj))
merge(before::T,      cached::T,after::T)       where T <: Extendable = append(append(before,cached),after)
merge(before::Nothing,cached::T,after::T)       where T <: Extendable = append(cached,after)
merge(before::T,      cached::T,after::Nothing) where T <: Extendable = append(before,cached)
merge(before::Nothing,cached::T,after::Nothing) where T <: Extendable = cached


######### Optionalble Redefineable Interfaces
# If you want 1 preallocation and merge all the three there at once
# is_same(o1::T, o2::T)       where T = (throw("Unimplemented is_same(...)"); return o1.config == o2.config && o1.fr == o2.fr && o1.to == o2.to) 
append(before::T, after::Nothing) where T <: Extendable = before 
append(before::Nothing, after::T) where T <: Extendable = after

data_before(obj::T, c::T)         where T <: Extendable = need_data_before(obj,c) ? load_data!(init_before_data(obj,c)) : nothing
data_after(c::T,  obj::T)         where T <: Extendable = need_data_after(obj,c)  ? load_data!(init_after_data(obj,c))  : nothing


######### REDEFINE
# Concat two data with same config.
append(before::T, after::T)      where T <: Extendable = throw("Implement the merging process, how do you concat two $T")

# Do we need new data (in front/after) of our current data?
need_data_before(obj::T, c::T)   where T <: Extendable = obj.fr < c.fr
need_data_after(obj::T,  c::T)   where T <: Extendable = c.to < obj.to

# Configure and init the (before/after) object that is able to download the right data with load_data
init_before_data(obj::T, c::T)   where T <: Extendable = init(T, obj.fr, c.fr, obj.config)
init_after_data(obj::T,  c::T)   where T <: Extendable = init(T, c.to, obj.to, obj.config)





end # module ExtendableStruct
