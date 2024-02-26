module ExtendableStruct

using InitLoadableStruct: InitableLoadable, load_data!, init
using Unimplemented

export extend!

abstract type Extendable <: InitableLoadable end

######## Core functions
extend!(obj,c_obj)                           = merge(data_before(obj, c_obj), c_obj, data_after(c_obj, obj))
merge(before,         cached,after)          = append(append(before,cached),after), true
merge(before::Nothing,cached,after)          = append(cached,after), true
merge(before,         cached,after::Nothing) = append(before,cached), true
merge(before::Nothing,cached,after::Nothing) = cached, false


######### Optionalble Redefineable Interfaces
# If you want 1 preallocation and merge all the three there at once
# is_same(o1::T, o2::T)       where T = (throw("Unimplemented is_same(...)"); return o1.config == o2.config && o1.fr == o2.fr && o1.to == o2.to) 
append(before,          after::Nothing) = before 
append(before::Nothing, after)          = after

data_before(obj, c)         = need_data_before(obj,c) ? load_data!(init_before_data(obj,c)) : nothing
data_after(c,  obj)         = need_data_after(obj,c)  ? load_data!(init_after_data(obj,c))  : nothing


######### REDEFINE
# Concat two data with same config.
@interface append(before::T, after::T)      where T # = throw("Implement the merging process, how do you concat two $T")

# Do we need new data (in front/after) of our current data?
@interface need_data_before(obj::T, c::T)   where T # = obj.fr < c.fr
@interface need_data_after(obj::T,  c::T)   where T # = c.to < obj.to

# Configure and init the (before/after) object that is able to download the right data with load_data
@interface init_before_data(obj::T, c::T)   where T # = init(T, obj.config, obj.fr, c.fr)
@interface init_after_data(obj::T,  c::T)   where T # = init(T, obj.config, c.to, obj.to)





end # module ExtendableStruct
