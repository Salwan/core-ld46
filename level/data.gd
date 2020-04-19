# Autoloaded

extends Node

enum ePopulation { RATE, TOTAL }

class cEnemy:
	
	var id:String
	var start:float
	var end:float
	var rate:float
	var total:int
	var maxAlive:int
	var population:int

	func _init(data):
		print("Parsing enemy data..")
		id = str(data.id)
		start = float(data.start)
		end = float(data.end)
		if data.has("rate"):
			rate = float(data.rate)
			population = ePopulation.RATE
		elif data.has("total"):
			total = int(data.total)
			population = ePopulation.TOTAL
		if data.has("maxAlive"):
			maxAlive = int(data.maxAlive)
		assert(len(id) > 0)
		assert(end > 0.0)
		assert(rate > 0.0 or total > 0)
		print("- id: " + id)
		print("- start: " + str(start))
		print("- end: " + str(end))
		print("- rate: " + str(rate))
		print("- total: " + str(total))
		print("- maxAlive: " + str(maxAlive))

class cLevel:

	var name:String
	var time:float
	var enemies:Array

	func _init(data):
		print("Parsing level data..")
		# Only one key expected at top of level json
		for n in data:
			name = str(n)
			break
		print("- Name: " +name)
		time = float(data[name].time)
		print("- Time: " + str(time))
		enemies = []
		for e in data[name].enemies:
			enemies.append(cEnemy.new(e))
		assert(len(enemies) > 0)
		assert(time > 0.0)


const Levels:Array = ["""{
	"beginnings": {
		"time": 50,
		"enemies": [
			{
				"id": "circle",
				"start": 2,
				"end": 55,
				"rate": 1.5
			}, {
				"id": "heal",
				"start": 20,
				"end": 25,
				"total": 2
			}
		]
	}
}
""", """{
	"insurgence": {
		"time": 60,
		"enemies": [
			{
				"id": "square",
				"start": 2,
				"end": 35,
				"rate": 1.5
			},{
				"id": "square",
				"start": 40,
				"end": 60,
				"rate": 1.2
			}, {
				"id": "triangle",
				"start": 35,
				"end": 60,
				"rate": 4.27
			}, {
				"id": "heal",
				"start": 20,
				"end": 25,
				"total": 2
			}
		]
	}
}""", """{
	"epiphany": {
		"time": 70,
		"enemies": [
			{
				"id": "square",
				"start": 2,
				"end": 35,
				"rate": 1.5
			},{
				"id": "square",
				"start": 36,
				"end": 60,
				"rate": 1.2
			}, {
				"id": "triangle",
				"start": 25,
				"end": 45,
				"rate": 3.0
			}, {
				"id": "circle",
				"start": 50,
				"end": 60,
				"rate": 1
			}, {
				"id": "heal",
				"start": 20,
				"end": 25,
				"total": 2
			}, {
				"id": "heal",
				"start": 45,
				"end": 55,
				"total": 3
			}, {
				"id": "heal",
				"start": 60,
				"end": 65,
				"total": 4
			}
		]
	}
}"""]

func CreateLevel(level_index:int):
	var d = GetData(level_index)
	assert(typeof(d) == TYPE_DICTIONARY)
	return cLevel.new(d)

func GetData(level_index:int):
	var v = validate_json(Levels[level_index])
	if v:
		push_error("Error validating level " + str(level_index) + " json: " + str(v))
		get_tree().quit()
	else:
		return parse_json(Levels[level_index])

func GetLevelCount():
	return len(Levels)
