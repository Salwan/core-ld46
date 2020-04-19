# Autoloaded

extends Node

enum ePopulation { RATE, TOTAL }

class cEnemy:
	
	var bg:String
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
	var bg:String

	func _init(data):
		print("Parsing level data..")
		# Only one key expected at top of level json
		for n in data:
			name = str(n)
			break
		print("- Name: " +name)
		bg = str(data[name].bg)
		print("- bg color: " + bg)
		time = float(data[name].time)
		print("- Time: " + str(time))
		enemies = []
		for e in data[name].enemies:
			enemies.append(cEnemy.new(e))
		assert(len(enemies) > 0)
		assert(time > 0.0)


const Levels:Array = ["""{
	"beginnings": {
		"bg": "#80050505",
		"time": 64,
		"enemies": [
			{
				"id": "square",
				"start": 2,
				"end": 55,
				"rate": 1.5
			}, {
				"id": "heal",
				"start": 20,
				"end": 25,
				"total": 2
			}, {
				"id": "heal",
				"start": 55,
				"end": 62,
				"total": 5
			}
		]
	}
}
""", """{
	"insurgence": {
		"bg": "#0adf7126",
		"time": 62,
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
			}, {
				"id": "heal",
				"start": 50,
				"end": 60,
				"total": 5
			}
		]
	}
}""", """{
	"epiphany": {
		"bg": "#0f5b6ee1",
		"time": 88,
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
				"rate": 1.5
			}, {
				"id": "boss",
				"start": 65,
				"end": 70,
				"total": 1
			}, {
				"id": "square",
				"start": 65,
				"end": 85,
				"rate": 1.2
			}, {
				"id": "heal",
				"start": 20,
				"end": 25,
				"total": 2
			}, {
				"id": "heal",
				"start": 45,
				"end": 55,
				"total": 7
			}, {
				"id": "heal",
				"start": 60,
				"end": 65,
				"total": 5
			}
		]
	}
}""", """{
	"reflection": {
		"bg": "#0fd77bba",
		"time": 109,
		"enemies": [
			{
				"id": "triangle",
				"start": 2,
				"end": 20,
				"rate": 1.5
			},{
				"id": "square",
				"start": 26,
				"end": 40,
				"rate": 1.2
			}, {
				"id": "circle",
				"start": 30,
				"end": 45,
				"rate": 3
			}, {
				"id": "triangle",
				"start": 43,
				"end": 60,
				"rate": 3.5
			}, {
				"id": "circle",
				"start": 50,
				"end": 65,
				"rate": 2
			}, {
				"id": "square",
				"start": 68,
				"end": 99,
				"rate": 1.1
			}, {
				"id": "boss",
				"start": 70,
				"end": 76,
				"rate": 2.5
			}, {
				"id": "heal",
				"start": 20,
				"end": 25,
				"total": 2
			}, {
				"id": "heal",
				"start": 45,
				"end": 55,
				"total": 7
			}, {
				"id": "heal",
				"start": 70,
				"end": 80,
				"total": 6
			}, {
				"id": "heal",
				"start": 95,
				"end": 100,
				"total": 5
			}, {
				"id": "win",
				"start": 101,
				"end": 103,
				"total": 1
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
