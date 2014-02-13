
# l = (args...) -> console.log.apply console, args 

root = @

previousDef = root.m_
previousDef$ = root.m$

m_ = (obj) ->
  if obj instanceof m_
    obj
  else if not (@ instanceof m_)
    new m_(obj)
  else
    @_wrapped = if mori.is_collection(obj) then obj else mori.js_to_clj(obj)
    return

# this is all about compatability with other environments
# hasn't been tested yet
if typeof exports != 'undefined'
  if typeof module != 'undefined' && module.exports
    exports = module.exports = m_
  else
    exports.m_ = m_
else 
  root.m_ = m_

m_.noConflict = () ->
  root.m_ = previousDef
  root.m$ = previousDef$
  m_

m_.prototype.to_js = () -> mori.clj_to_js(@_wrapped)

m_.chain = (obj) -> m_(obj).chain()

root.m$ = m_.chain

m_.prototype.chain = () ->
  @_chain = true
  @

m_.prototype.value = () -> @_wrapped

dont_chain = mori.list "list",
                    "vector",
                    "hash_map",
                    "set",
                    "sorted_set",
                    "range",
                    "iterate",
                    "repeat",
                    "repeatedly",
                    "prim_seq",
                    "identity",
                    "constantly",
                    "inc",
                    "dec",
                    "sum",
                    "is_even",
                    "is_odd",
                    "comp",
                    "juxt",
                    "knit",
                    "pipeline",
                    "partial",
                    "curry",
                    "fnil",
                    "js_to_clj",
                    "clj_to_js",
                    "equals",
                    "hash"

mori.each dont_chain, (name) -> m_[name] = mori[name]

end_of_chain = m_.list "is_list",
                       "is_seq",
                       "is_vector",
                       "is_map",
                       "is_set",
                       "is_collection",
                       "is_sequential",
                       "is_associative",
                       "is_counted",
                       "is_indexed",
                       "is_reduceable",
                       "is_seqable",
                       "is_reversible"

mori.each end_of_chain, (name) ->
    m_[name] = mori[name]
    m_.prototype[name] = () ->
      mori[name](@_wrapped)

# these should be chainable

arg_first = m_.list "conj",
                    "into",
                    "assoc",
                    "dissoc",
                    "empty",
                    "get",
                    "get_in",
                    "has_key",
                    "find",
                    "nth",
                    "last",
                    "assoc_in",
                    "update_in",
                    "count",
                    "is_empty",
                    "peek",
                    "pop",
                    "zipmap",
                    "reverse",
                    "each",
                    "subvec",
                    "keys",
                    "vals",
                    "disj",
                    "union",
                    "intersection",
                    "difference",
                    "is_subset",
                    "is_superset",
                    "first",
                    "rest",
                    "seq",
                    "concat",
                    "flatten",
                    "into_array"

result = (obj) ->
  if @_chain then m_(obj).chain() else obj

mori.each arg_first, (name) ->
  m_[name] = mori[name]
  m_.prototype[name] = (args...) ->
    args.unshift(@_wrapped)
    result.call(@, mori[name].apply(mori, args))

coll_last = m_.list "cons",
                    "map",
                    "mapcat",
                    "filter",
                    "remove",
                    "reduce",
                    "reduce_kv",
                    "take",
                    "take_while",
                    "drop",
                    "drop_while",
                    "some",
                    "every",
                    "sort",
                    "sort_by",
                    "interpose",
                    "interleave",
                    "partition",
                    "partition_by",
                    "group_by"

mori.each coll_last, (name) ->
  m_[name] = mori[name]
  m_.prototype[name] = (args...) ->
    args.push(@_wrapped)
    result.call(@, mori[name].apply(mori, args))

#m_([1,2,3,4]).each (x) -> l(x)

#l m$({ hello: 5, goodbye: 7}).assoc("johnner", 6, "margy", 5).to_js()

#l m$({ hello: 5, goodbye: 7}).assoc("jabber", 4).assoc("nagger", 7).to_js()

#l m$({ hello: 5, goodbye: 7}).keys().to_js();

#l m$([1,2,3,4,5,6,7,8]).subvec(1,3).to_js();
