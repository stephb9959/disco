%
% simple graph library 
% developed to store network information
%

% graph is a tuple containing two dictionaries and a list: 
% one dict contains node-list of neighbors key-values 
% another dict contains pairs of {box1,box2}-list of links that connects boxes

-module(neph).
-export([new/1,size/1,
		has_box/2,
		boxe_list/1,
		neighbor/3,
		neighbor_boxes/2,
		neighbors/2,
		add_neighbor/5,
		del_wire/5
		%export_to_dot/2
		]).


% creates new network
new(Box) -> dict:store(Box,[],dict:new()).  

% returns size of known network
size(Net_data) -> dict:size(Net_data).


% returns true/false if Graph has/has_not Node  
has_box(Box,Net_data) -> dict:is_key(Box,Net_data).
	

% returns the all boxes in the network (known for a given box)
boxe_list(Net_data) -> dict:fetch_keys(Net_data).


% returns {Neighbor_port, Neighbor_box} or not_connected
neighbor(Box_id,Port,Net_data) ->
	Neighbors = dict:fetch(Box_id,Net_data),
	case lists:keyfind(Port,1,Neighbors) of
		false -> not_connected;
		{Port,Nei_port,Nei_box} -> {Nei_port,Nei_box}
	end.


% returns a list of {port1,port2,box2} triples for each Neighbor
neighbors(Box_id,Net_data) -> dict:fetch(Box_id,Net_data).


% returns all neighbor boxes for a given box
neighbor_boxes(Box_id,Net_data) ->
	[ B || {_,_,B} <- dict:fetch(Box_id,Net_data)].


% returns Net_data1 after removing a connection between boxes
del_wire(Box1,Port1,Port2,Box2,Net_data) ->
	Neighbors1 = dict:fetch(Box1,Net_data),
	Neighbors11=lists:keydelete(Port1,1,Neighbors1),
	
	Neighbors2 = dict:fetch(Box2,Net_data),
	Neighbors22=lists:keydelete(Port2,1,Neighbors2),

	dict:store(Box2,Neighbors22,dict:store(Box1,Neighbors11,Net_data)).



% returns updated Net_data after adding a new box connected over given ports
add_neighbor(Box1,Port1,Port2,Box2,Net_data) ->
	case dict:is_key(Box1,Net_data) of
		true -> 
			Net1 = dict:store(Box1,lists:usort([ {Port1,Port2,Box2} | dict:fetch(Box1,Net_data)]),Net_data);
		false ->
			Net1 = dict:store(Box1,[{Port1,Port2,Box2}],Net_data)
	end,

	case dict:is_key(Box2,Net1) of
		true -> 
			dict:store(Box2,lists:usort([ {Port2,Port1,Box1} | dict:fetch(Box2,Net1)]),Net1);
		false ->
			dict:store(Box2,[{Port2,Port1,Box1}],Net1)
	end.
	

