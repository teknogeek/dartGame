import 'dart:math';

class LevelMap
{
	//Grass : 0
	//Water : 1
	List<List> map = new List();
  
	LevelMap(int width, int height)
	{
		int numY = height ~/ 32;
		int numX = width ~/ 32;
		for(int y = 0; y < numY; y++)
		{
			List xList = new List();
			for(int x = 0; x < numX; x++)
			{
				int tileInt = new Random().nextInt(10);
				tileInt = (0 <= tileInt && tileInt <= 7) ? 0 : 1;
				
				if(y > 0 && x > 0)
				{
					if(map[y - 1][x - 1] != 1 && map[y - 1][x] != 1 && xList[x - 1] != 1 && tileInt == 1)
					{
						map[y - 1][x - 1] = 1;
						map[y - 1][x] = 1;
						xList[x - 1] = 1;
					}
				}
				
				xList.add(tileInt);
			}
			map.add(xList);
		}
	}
}