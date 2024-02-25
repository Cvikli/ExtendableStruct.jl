module ExtendableStruct

using InitLoadableStruct: InitableLoadable, load_data!, init
using Unimplemented

export extend!

abstract type Extendable <: InitableLoadable end

######## Core functions
extend!(obj::T,c_obj::T)                        where T = merge(data_before(obj, c_obj), c_obj, data_after(c_obj, obj))
merge(before::T,      cached::T,after::T)       where T = append(append(before,cached),after), true
merge(before::Nothing,cached::T,after::T)       where T = append(cached,after), true
merge(before::T,      cached::T,after::Nothing) where T = append(before,cached), true
merge(before::Nothing,cached::T,after::Nothing) where T = cached, false


######### Optionalble Redefineable Interfaces
# If you want 1 preallocation and merge all the three there at once
# is_same(o1::T, o2::T)       where T = (throw("Unimplemented is_same(...)"); return o1.config == o2.config && o1.fr == o2.fr && o1.to == o2.to) 
append(before::T, after::Nothing) where T = before 
append(before::Nothing, after::T) where T = after

data_before(obj::T, c::T)         where T = need_data_before(obj,c) ? load_data!(init_before_data(obj,c)) : nothing
data_after(c::T,  obj::T)         where T = need_data_after(obj,c)  ? load_data!(init_after_data(obj,c))  : nothing


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
