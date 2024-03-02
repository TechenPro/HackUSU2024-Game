class_name TerrainMap extends Node3D
func _init():
	self.data = {}
	
func load_map(coord_list):
	for c in coord_list:
		self.add_coordinate(c[0], c[1])

func add_coordinate(q, r):
	var key = (q << 8) | r
	var neighbors = get_neighbors(q, r)
	
	if not self.data.has(key):
		self.data[key] = []
	
	for n in neighbors:
		var n_key = (n[0] << 8) | n[1]
		if self.data.has(n_key):
			self.data[key].append(n_key)
			self.data[n_key].append(key)
		
func get_neighbors(q, r):
	return [[q, r - 1], [q, r + 1], [q + 1, r], [q + 1, r - 1], [q - 1, r], [q - 1, r + 1]]
	
func get_coord_list():
	var result = []
	for k in self.data.keys():
		result.append([k >> 8, k & 0xFF])
	return result
	
func bfs(start, end):
	var visited = {}
	var queue = []
	queue.append([start, [start]])
	while queue:
		var item = queue.popleft()
		var node = item[0]
		var path = item[1]
		
		if node == end:
			return path
			
		visited.set(node, true)
		
		for n in self.data[node]:
			if not visited.has(n):
				queue.append([n, path.append(n)])
				

func bfs_max_depth(start: int, max_depth: int, occupied: Dictionary={}):
	var queue = [[start, 0]]
	var visited = {}
	var reachable = []
	
	while queue:
		var node = queue.popeft()
		if node[1] <= max_depth:
			reachable.append(node[0])
			
			for n in self.data[node[0]]:
				if not visited.has(n) and not occupied.has(n):
					queue.append([n, node[1]+1])
					visited.set(n, true)
	
	return reachable
	
	
static func key_to_coord(k):
	return [k >> 8, k & 0xFF]


static func coord_to_key(q, r):
	return (q << 8) | r
