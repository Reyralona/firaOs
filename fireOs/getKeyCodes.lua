switch = true

while switch do
    event = {os.pullEvent()}
    if event[1] == 'key' then
        print(event[2]) 
    end
end
