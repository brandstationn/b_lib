if not IsDuplicityVersion() then
    Funcs, Streaming, FrameworkBased, Math, Admin, DefaultLocale = exports['b_lib']:Fetch()
else
    Funcs, FrameworkBased = exports['b_lib']:Fetch()
end
