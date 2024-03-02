class_name TerrainMap

var data : Dictionary

func _init():
	data = {}
	
func load_map(coord_list):
	for c in coord_list:
		add_coordinate(c[0], c[1])

func add_coordinate(q, r):
	var key = (q << 16)|r
	var neighbors = get_neighbors(q, r)
	
	if not data.has(key):
		data[key] = []
	
	for n in neighbors:
		var n_key = (n[0] << 16)|n[1]
		if data.has(n_key):
			data[key].append(n_key)
			data[n_key].append(key)
		
func get_neighbors(q, r):
	return [[q, r - 1], [q, r + 1], [q + 1, r], [q + 1, r - 1], [q - 1, r], [q - 1, r + 1]]
	
func get_coord_list():
	var result = []
	for k in data.keys():
		result.append([k >> 16, k&0xFF])
	return result

# Returns a path from the given start to the end if possible 
func bfs(start, end, max_range, occupied={}):
	var visited = {}
	var queue = []
	queue.append([start, [start], 0])
	while queue:
		var item = queue.pop_front()
		var node = item[0]
		var path = item[1]
		var dist = item[2]
		
		if node == end and dist <= max_range:
			return path
		
		for n in data[node]:
			if not visited.has(n) and not occupied.has(n):
				queue.append([n, path.append(n), dist + 1])
				visited[node]= true

# Returns a list of all locations that are within the given range from the start
func get_reachable_locations(start, max_range, occupied={}):
	var queue = [[start, 0]]
	var visited = {}
	var reachable = []
	
	while queue:
		var node = queue.pop_front()
		if node[1] <= max_range:
			reachable.append(node[0])
			
			for n in data[node[0]]:
				if not visited.has(n) and not occupied.has(n):
					queue.append([n, node[1] + 1])
					visited[n]= true
	
	return reachable

static func key_to_coord(k):
	return [k >> 16, k&0xFF]

static func coord_to_key(q, r):
	return (q << 16)|r
