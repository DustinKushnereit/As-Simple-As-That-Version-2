package
{
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import flash.geom.*
	import flash.display.*
	
	[SWF(width="800", height="600", frameRate="30", backgroundColor="0x00000")]
	
	public class Main extends MovieClip
	{		
		//Gameplay Objects
		public var middleObject:Sprite = new Sprite();
		public var theShield:MovieClip = new MovieClip();		
		public var gameBorder:MovieClip = new MovieClip();
		public var mainStar:MovieClip;
		
		public var displayHolderLeft:Sprite = new Sprite();
		public var displayHolderRight:Sprite = new Sprite();
		public var displayHolderBotLeft:Sprite = new Sprite();
		public var displayHolderBotRight:Sprite = new Sprite();
		
		public var displayObject:MovieClip = new MovieClip();
		public var displayScreen:MovieClip = new MovieClip();
		public var displayText:TextField = new TextField;
		
		public var winScreen:MovieClip = new MovieClip();
		public var loseScreen:MovieClip = new MovieClip();
		
		public var healthBarFill:MovieClip = new MovieClip();
		public var healthBarBorder:MovieClip = new MovieClip();
		
		public var spiritualBarFill:MovieClip = new MovieClip();
		public var spiritualBarBorder:MovieClip = new MovieClip();
		
		public var energyText:TextField;
		public var spiritualText:TextField;
		//public var powerUpText:TextField = new TextField;
		public var shieldText:TextField = new TextField;
		
		
		//Art
		[Embed(source = "../art/Character.png")]
		private const playerImage:Class;
		public var imagePlayer:DisplayObject = new playerImage;
		
		[Embed(source="../art/Deed.png")]
		private const deedImage:Class;
		public var imageDeed:DisplayObject;
		
		[Embed(source="../art/Temptation.png")]
		private const temptationImage:Class;
		public var imageTemptation:DisplayObject;
		
		[Embed(source = "../art/Task_1_Trashcan.png")]
		private const enemyImage:Class;
		public var imageEnemy:DisplayObject;
		
		[Embed(source = "../art/Task_2_Washdishes.png")]
		private const reverseEnemyImage:Class;
		public var imageReverseEnemy:DisplayObject;
		
		[Embed(source = "../art/Lantern.png")]
		private const lanternImage:Class;
		public var imageLantern:DisplayObject = new lanternImage;
		
		[Embed(source = "../art/Shield.png")]
		private const shieldImage:Class;
		public var imageShield:DisplayObject;
		
		[Embed(source = "../art/Day_Background.png")]
		private const dayImage:Class;
		public var imageDay:DisplayObject = new dayImage;
		
		[Embed(source = "../art/Night_Background.png")]
		private const nightImage:Class;
		public var imageNight:DisplayObject = new nightImage;
		
		//Booleans
		public var makeDeed:Boolean = false;
		public var makeTemptation:Boolean = false;
		public var hitEnemy:Boolean = false;
		public var clockWise:Boolean = false;
		public var stopMoving:Boolean = false;
		public var resizeShip:Boolean = true;
		public var hitTemptation:Boolean = false;
		public var shield:Boolean = false;
		public var startCountDown:Boolean = false;
		public var rotateStar:Boolean = false;
		public var teleportNight:Boolean = false;
		
		
		//Ship Variables
		public var ship:MovieClip = new MovieClip();
		public var glow:GlowFilter = new GlowFilter();
		
		
		//Gameplay Variables
		public var enemy:Enemy;
		public var reverseEnemy:ReverseEnemy;
		public var deed:Deeds;
		public var temptation:Temptation;
		
		public var lives:int = 0;
		private var _root:Object;
		
		public var score:int = 0;
		public var enemyTime:int = 0;
		public var enemyLimit:int = 18;
		public var reverseEnemyTime:int = 0;
		public var reverseEnemyLimit:int = 18;
		public var myFormat:TextFormat = new TextFormat;
		
		public var time:int = 0;
		public var timeDisplay:int = 0;
		public var countDownTimer:int = 0;
		public var countDownTimerDisplay:int = 0;
		public var shieldCountDownTimer:int = 0;
		public var shieldCountDownTimerDisplay:int = 0;
		
		
		//Rotation Variables
		public var angle:Number = 0;
		public var starAngle:Number = 0;
		public var speed:Number = 1;
		public var radius:Number = 125;
		
		
		//GUI Bar Variables
		public var fillType:String = GradientType.LINEAR;
		public var colors:Array = [0xFF0000, 0x0000FF];
		public var alphas:Array = [1, 1];
		public var ratios:Array = [0x00, 0xFF];
		public var matr:Matrix = new Matrix();
		public var spreadMethod:String = SpreadMethod.PAD;
		
		public function Main()
		{
			_root = MovieClip(root);
			
			beginGame();
			stage.addEventListener(MouseEvent.CLICK, startGame);
		}
		
		public function beginGame():void
		{
			displayScreen.graphics.beginFill(0xB90000, 1);
			displayScreen.graphics.moveTo(0, 0); 
			displayScreen.graphics.lineTo(740, 0);
			displayScreen.graphics.lineTo(740, 540);
			displayScreen.graphics.lineTo(0, 540);
			displayScreen.graphics.lineTo(0, 0);
			displayScreen.x = 30;
			displayScreen.y = 30;
			addChild(displayScreen);
			
			//makeLeftCircle();
			
			//makeRightCircle();
			
			//makeBotLeftCircle();
			
			makeBotRightCircle();
		}
		
		public function startGame(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.CLICK, startGame);
			removeChild(displayScreen);
			//removeChild(displayHolderLeft);
			//removeChild(displayHolderRight);
			//removeChild(displayHolderBotLeft);
			removeChild(displayHolderBotRight);
			
			/*imageDay.width = 800;
			imageDay.height = 600;
			imageNight.width = 800;
			imageNight.height = 600;*/
			imageDay.x = 0;
			imageDay.y = 998;
			imageNight.x = 0;
			imageNight.y = 0;
			addChild(imageDay);
			addChild(imageNight);
			
			teleportNight = false;
			makeDeed = true;
			makeTemptation = true;
			score = 0;
			enemyLimit = 60;
			reverseEnemyLimit = 60;
			lives = 10;
			clockWise = true;
			stopMoving = false;
			time = 7500;
			countDownTimer = 650;
			shield = false;
			startCountDown = false;
			shieldCountDownTimer = 275;
			rotateStar = true;
			starAngle = -20;
			angle = 0;
			speed = 1;
			var dimensions:int = 12;
			
			mainStar = new MovieClip();
			mainStar.graphics.lineStyle(2, 0xCCFFFF);
			mainStar.graphics.beginFill(0xCCFFFF, 2);
			drawStar(mainStar.graphics, 0, 0, 6, 8, 35, 0);
			mainStar.x = 10;
			mainStar.y = 400;			
			glow = new GlowFilter();
			glow.color = 0xCCFFFF;
			glow.alpha = 15;
			glow.blurX = 10;
			glow.blurY = 10;
			glow.quality = BitmapFilterQuality.HIGH;
			mainStar.filters = [glow];
			//stage.addChild(mainStar);
			
			//Score Bar------------------------------Start----------------------------------------------
			spiritualBarBorder.graphics.lineStyle(3, 0xFF00FF);
			spiritualBarBorder.graphics.beginFill(0x000000, 0);
			spiritualBarBorder.graphics.drawRect(0, 0, 183, 28);
			spiritualBarBorder.x = 13;
			spiritualBarBorder.y = 13;
			
			glow = new GlowFilter();
			glow.color = 0xFF00FF;
			glow.alpha = 4;
			glow.blurX = 8;
			glow.blurY = 8;
			glow.quality = BitmapFilterQuality.HIGH;
			spiritualBarBorder.filters = [glow];
			
			stage.addChild(spiritualBarBorder);
			
			colors = [0x0000FF, 0xFF00FF];
			matr.createGradientBox(200, 25, 0, 0, 0);
			
			spiritualBarFill.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);        
			spiritualBarFill.graphics.drawRect(0, 0, 200, 25);
			
			spiritualBarFill.x = 15;
			spiritualBarFill.y = 15;
			
			stage.addChild(spiritualBarFill);
			
			spiritualText = new TextField;
		
			myFormat.size = 22;
			myFormat.align = TextFormatAlign.CENTER;
			
			spiritualText.defaultTextFormat = myFormat;
			spiritualText.textColor = 0xFF00FF;
			spiritualText.x = spiritualBarFill.x + 40;
			spiritualText.y = spiritualBarFill.y - 4;
			spiritualText.text = "Energy";
			stage.addChild(spiritualText);
			//Score Bar------------------------------End----------------------------------------------------
			
			gameBorder.graphics.lineStyle(3, 0xFF0000);
			gameBorder.graphics.beginFill(0x000000, 0);
			gameBorder.graphics.drawRect(0, 0, 790, 590);
			gameBorder.x = 5;
			gameBorder.y = 5;
			
			glow = new GlowFilter();
			glow.color = 0xFF0000;
			glow.alpha = 4;
			glow.blurX = 8;
			glow.blurY = 8;
			glow.quality = BitmapFilterQuality.HIGH;
			gameBorder.filters = [glow];
			
			stage.addChild(gameBorder);
			
			//Health Bar------------------------------Start----------------------------------------------
			/*healthBarBorder.graphics.lineStyle(3, 0xFF6600);
			healthBarBorder.graphics.beginFill(0x000000, 0);
			healthBarBorder.graphics.drawRect(0, 0, 153, 28);*/
			healthBarBorder.x = 633;
			healthBarBorder.y = 13;
			
			glow = new GlowFilter();
			glow.color = 0xFF6600;
			glow.alpha = 4;
			glow.blurX = 8;
			glow.blurY = 8;
			glow.quality = BitmapFilterQuality.HIGH;
			healthBarBorder.filters = [glow];
			
			//stage.addChild(healthBarBorder);
			
			/*colors = [0xFFCC00, 0xFF0000];
			matr.createGradientBox(100, 25, 0, 0, 0);
			healthBarFill.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);        
			healthBarFill.graphics.drawRect(0, 0, lives * 15, 25);*/
			/*dimensions = 12;
			healthBarFill.graphics.beginFill (0x000000,0);
			healthBarFill.graphics.drawCircle( dimensions, dimensions, dimensions );
			
			healthBarFill.x = 635;
			healthBarFill.y = 15;
			
			stage.addChild(healthBarFill);*/
			
			healthBarFill.x = 635;
			healthBarFill.y = 15;
			
			energyText = new TextField;
		
			myFormat.size = 22;
			myFormat.align = TextFormatAlign.CENTER;
			
			energyText.defaultTextFormat = myFormat;
			energyText.textColor = 0xFFFF00;
			energyText.x = healthBarFill.x + 30;
			energyText.y = healthBarFill.y - 4;
			energyText.text = "Spiritual";
			//stage.addChild(energyText);
			//Health Bar------------------------------End----------------------------------------------------
			
			glow.color = 0x33FF00;
			glow.alpha = 2;
			glow.blurX = 5;
			glow.blurY = 5;
			glow.quality = BitmapFilterQuality.HIGH;
			
			dimensions = 12;
			//ship.graphics.lineStyle(1, 0x000000);
			ship.graphics.drawCircle( dimensions, dimensions, dimensions );
			//ship.filters = [glow];
			ship.alpha = 0;
			stage.addChild(ship);
			
			dimensions = 10;
			middleObject.graphics.drawCircle( dimensions, dimensions, dimensions );
			middleObject.x = stage.stageWidth / 2;
			middleObject.y = 250;
			
			addChild(middleObject);
			//stage.addChild(powerUpText);
			
			stage.addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
			
			addChild(imagePlayer);
	
			imageLantern.x = 392;
			imageLantern.y = 225;
			addChild(imageLantern);
		}

		public function keyPressed( event:KeyboardEvent ):void
		{
			if ( event.keyCode == Keyboard.RIGHT )
			{
				clockWise = true;
				speed = 4;
			}
			else if ( event.keyCode == Keyboard.LEFT ) 
			{
				clockWise = false;
				speed = 4;
			}
			else if ( event.keyCode == Keyboard.UP )
				stopMoving = true;
			else if ( event.keyCode == Keyboard.DOWN )
				stopMoving = true;
			else if ( event.keyCode == Keyboard.W )
				score = 20;
			else if ( event.keyCode == Keyboard.L )
				hitEnemy = true;
			else if ( event.keyCode == Keyboard.S )
				countDownTimer = 0;
			else if ( event.keyCode == Keyboard.D )
			{
				imageNight.y = -800;
				imageDay.y = 198;
			}
			else if ( event.keyCode == Keyboard.N )
			{
				imageDay.y = -800;
				imageNight.y = 198;
			}
				
		}
		
		public function keyReleased( event:KeyboardEvent ):void
		{
			if ( event.keyCode == Keyboard.DOWN ) 
				stopMoving = false;
			if ( event.keyCode == Keyboard.UP ) 
				stopMoving = false;
			if ( event.keyCode == Keyboard.RIGHT ) 
				speed = 1;
			if ( event.keyCode == Keyboard.LEFT ) 
				speed = 1;
		}

		public function update(e:Event):void
		{			
			time--;
			timeDisplay = time / 25;
			
			countDownTimer--;
			countDownTimerDisplay = countDownTimer / 25;
			
			createEnemies();
			
			createReverseEnemies();
				
			if( makeDeed )
				createDeed();
				
			if( makeTemptation )
				createTemptation();
			
			if ( hitEnemy || score >= 20 || time <= 0)
				endGame();
				
			//resizeMe(healthBarFill, lives * 15, lives * 15, true);
			
			imageLantern.alpha = lives / 10;
			
			resizeMe(spiritualBarFill, .6 * timeDisplay, spiritualBarFill.height, true);
			
			//if ( rotateStar )
				//rotateMainStar();
			
			if (!stopMoving)
				rotateAroundMiddle();
				
			//showBarText();
			checkTemptation();
			
			if (shield)
			{
				makeShield();
				startCountDown = true;
				shield = false;
				shieldCountDownTimer = 275;
				stage.addChild(shieldText);
			}
			
			if (startCountDown)
				shieldCountDown();
				
			imageDay.y -= .8;
			imageNight.y -= .8;
			
			if (imageDay.y <= 0 && teleportNight == false)
			{
				teleportNight = true;
				imageNight.y = 996;
			}
			
			if (imageNight.y <= 0 && teleportNight == true)
			{
				teleportNight = false;
				imageDay.y = 994;
			}
				
		}
		
		public function shieldCountDown():void 
		{
			shieldCountDownTimer--;
			shieldCountDownTimerDisplay = shieldCountDownTimer / 25;
			
			myFormat.size = 22;
			myFormat.align = TextFormatAlign.CENTER;
			
			shieldText.defaultTextFormat = myFormat;
			shieldText.textColor = 0x00FF00;
			shieldText.x = 50;
			shieldText.y = 50;
			shieldText.width = 200;
			shieldText.text = "Shield: " + String(shieldCountDownTimerDisplay);
			
			if (shieldCountDownTimer <= 0)
			{
				startCountDown = false;
				shieldCountDownTimer = 275;
				stage.removeChild(shieldText);
				theShield.x = 2000;
				theShield.y = -2000;
				theShield.removeChild(imageShield);
				stage.removeChild(theShield);
			}
		}
		
		public function makeShield():void 
		{			
			glow.color = 0x33FF00;
			glow.alpha = 2;
			glow.blurX = 5;
			glow.blurY = 5;
			glow.quality = BitmapFilterQuality.HIGH;
			
			var dimensions:int = 200;
			//theShield.graphics.lineStyle(3, 0x00000);
			theShield.graphics.drawCircle( dimensions, dimensions, dimensions );
			//theShield.filters = [glow];
			theShield.x = 210;
			theShield.y = 60;
			stage.addChild(theShield);
			imageShield = new shieldImage;
			imageShield.x = 0;
			imageShield.y = 0;
			imageShield.width = 400;
			imageShield.height = 400;
			imageShield.alpha = .5;
			theShield.addChild(imageShield);
		}
		
		public function checkTemptation():void
		{
			if (countDownTimer <= 0 )
			{
				shield = true;
				countDownTimer = 650;
			}
				
			if (hitTemptation)
			{
				hitTemptation = false;
				//countDownTimer = 650;
			}
		}

		public function endGame():void
		{
			stage.removeEventListener(Event.ENTER_FRAME, update);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyReleased);
			stage.removeChild(ship);
			//stage.removeChild(healthBarBorder);
			//stage.removeChild(healthBarFill);
			stage.removeChild(gameBorder);
			stage.removeChild(spiritualBarBorder);
			stage.removeChild(spiritualBarFill);
			removeChild(middleObject);
			stage.removeChild(spiritualText);
			//stage.removeChild(energyText);
			//stage.removeChild(powerUpText);
			//stage.removeChild(mainStar);
			removeChild(imagePlayer);
			removeChild(imageLantern);
			removeChild(imageDay);
			removeChild(imageNight);
			
			startCountDown = false;
			shield = false;
			shieldCountDownTimer = 0;
			starAngle = -20;
			angle = 0;
			
			if (theShield.stage)
				stage.removeChild(theShield);
				
			if (shieldText.stage)
				stage.removeChild(shieldText);

			if( score >= 20 )
			{				
				addChild(winScreen);

				winScreen.graphics.lineStyle(5);
				winScreen.graphics.beginFill(0xFFCC00, 1);
				winScreen.graphics.drawEllipse(0, 0, 195, 190);
				
				winScreen.graphics.beginFill(0x000000);
				winScreen.graphics.drawEllipse(45, 47, 24, 37);
				
				winScreen.graphics.drawEllipse(124, 47, 24, 37);
				winScreen.graphics.endFill();
				
				winScreen.graphics.moveTo(39, 120);
				winScreen.graphics.curveTo(100, 190, 161, 120);
				
				winScreen.x = 310;
				winScreen.y = 200;
				
				stage.addEventListener(MouseEvent.CLICK, youWin);
			}
			else
			{
				addChild(loseScreen);
				
				loseScreen.graphics.lineStyle(5);
				loseScreen.graphics.beginFill(0xFF3603, 1);
				loseScreen.graphics.drawEllipse(0, 0, 195, 190);
				
				loseScreen.graphics.beginFill(0x000000);
				loseScreen.graphics.drawEllipse(45, 47, 24, 37);
				
				loseScreen.graphics.drawEllipse(124, 47, 24, 37);
				loseScreen.graphics.endFill();
				
				loseScreen.graphics.moveTo(39, 150);
				loseScreen.graphics.curveTo(110, 120, 161, 150);
				
				loseScreen.x = 310;
				loseScreen.y = 200;
				
				stage.addEventListener(MouseEvent.CLICK, youLose);
			}
		}

		public function youLose(e:MouseEvent):void
		{
			hitEnemy = false;
			removeChild(loseScreen);
			stage.removeEventListener(MouseEvent.CLICK, youLose);
			
			beginGame();
			stage.addEventListener(MouseEvent.CLICK, startGame);
		}

		public function youWin(e:MouseEvent):void
		{
			hitEnemy = false;
			removeChild(winScreen);
			stage.removeEventListener(MouseEvent.CLICK, youWin);
			
			beginGame();
			stage.addEventListener(MouseEvent.CLICK, startGame);
		}

		/*public function showBarText():void
		{	
			myFormat.size = 22;
			myFormat.align = TextFormatAlign.CENTER;
			
			powerUpText.defaultTextFormat = myFormat;
			powerUpText.textColor = 0x00FF00;
			powerUpText.x = 300;
			powerUpText.y = 15;
			powerUpText.width = 200;
			powerUpText.text = "Power Up in: " + String(countDownTimerDisplay);
		}*/
		
		public function createEnemies():void
		{
			if( enemyTime < enemyLimit )
				enemyTime++;
			else
			{		
				var dimensions:int = 10;
				var rangeY:Array = [ [ -40, -30], [630, 640] ]
				var spawnX:Number = int( Math.floor( Math.random() * ( 840 - ( -40) + 1 ) ) + ( -40) );
				var spawnY:Number = int( Math.floor( Math.random() * ( 640 - ( -40) + 1 ) ) + ( -40) );
				
				if (spawnX <= 820 && spawnX >= -20 )
					spawnY = randomFromRanges(rangeY);
				
				enemy = new Enemy();
				imageEnemy = new enemyImage;
				
				dimensions = 12;
				enemy.graphics.drawCircle( dimensions, dimensions, dimensions );
				//ship.filters = [glow];
				enemy.alpha = 1;
				
				/*enemy.graphics.lineStyle(4, 0xFF0000, 1);
				enemy.graphics.moveTo(0, 0); 
				enemy.graphics.lineTo(25, -25);
				enemy.graphics.lineTo(35, 0);
				enemy.graphics.lineTo(0, 0);*/
				
				enemy.x = spawnX;
				enemy.y = spawnY;
				
				glow = new GlowFilter();
				glow.color = 0xFFCC00;
				glow.alpha = 4;
				glow.blurX = 10;
				glow.blurY = 10;
				glow.quality = BitmapFilterQuality.HIGH;
				//enemy.filters = [glow];
				
				addChild(enemy);
				enemy.addChild(imageEnemy);
				enemyTime = 0;
			}
		}
		
		public function createReverseEnemies():void
		{
			if( reverseEnemyTime < reverseEnemyLimit )
				reverseEnemyTime++;
			else
			{
				var dimensions:int = 10;
				var rangeX:Array = [ [ -40, -30], [830, 840] ]
				var spawnX:Number = randomFromRanges(rangeX);
				var spawnY:Number = int( Math.floor( Math.random() * ( 640 - ( -40) + 1 ) ) + ( -40) );
				
				reverseEnemy = new ReverseEnemy();
				imageReverseEnemy = new reverseEnemyImage;
				
				dimensions = 12;
				reverseEnemy.graphics.drawCircle( dimensions, dimensions, dimensions );
				//ship.filters = [glow];
				reverseEnemy.alpha = 1;
				
				/*reverseEnemy.graphics.lineStyle(4, 0xFF0000, 1);
				reverseEnemy.graphics.moveTo(0, 0); 
				reverseEnemy.graphics.lineTo(25, -25);
				reverseEnemy.graphics.lineTo(35, 0);
				reverseEnemy.graphics.lineTo(0, 0);*/
				
				reverseEnemy.x = spawnX;
				reverseEnemy.y = spawnY;
				
				glow = new GlowFilter();
				glow.color = 0xFFCC00;
				glow.alpha = 4;
				glow.blurX = 10;
				glow.blurY = 10;
				glow.quality = BitmapFilterQuality.HIGH;
				//reverseEnemy.filters = [glow];
				
				addChild(reverseEnemy);
				reverseEnemy.addChild(imageReverseEnemy);
				reverseEnemyTime = 0;
			}
		}
		
		public function createDeed():void
		{
			if ( makeDeed )
			{
				var dimensions:int = 10;
				var rangeY:Array = [ [ -20, -10], [610, 620] ]
				var spawnX:Number = int( Math.floor( Math.random() * ( 820 - ( -20) + 1 ) ) + ( -20) );
				var spawnY:Number = int( Math.floor( Math.random() * ( 620 - ( -20) + 1 ) ) + ( -20) );
				
				if (spawnX <= 805 && spawnX >= 5 )
					spawnY = randomFromRanges(rangeY);

				deed = new Deeds();
				imageDeed = new deedImage;
				//deed.graphics.lineStyle(2, 0xFF00FF);
				//deed.graphics.beginFill(0xFF00FF, 2);
				//drawStar(deed.graphics, 0, 0, 5, 2, 15, 0);
				
				dimensions = 12;
				deed.graphics.drawCircle( dimensions, dimensions, dimensions );
				
				deed.x = spawnX;
				deed.y = spawnY;
				
				addChild(deed);
				deed.addChild(imageDeed);
				makeDeed = false;
			}
		}
		
		public function createTemptation():void
		{
			if ( makeTemptation )
			{
				var dimensions:int = 10;
				var rangeY:Array = [ [ -20, -10], [610, 620] ]
				var spawnX:Number = int( Math.floor( Math.random() * ( 820 - ( -20) + 1 ) ) + ( -20) );
				var spawnY:Number = int( Math.floor( Math.random() * ( 620 - ( -20) + 1 ) ) + ( -20) );
				
				if (spawnX <= 805 && spawnX >= 5 )
					spawnY = randomFromRanges(rangeY);
				
				temptation = new Temptation();
				imageTemptation = new temptationImage;
				
				//temptation.graphics.lineStyle(2, 0xFF0000);
				//temptation.graphics.beginFill(0xFF0000, 2);
				//drawStar(temptation.graphics, 0, 0, 6, 12, 15, 0);
				
				dimensions = 12;
				temptation.graphics.drawCircle( dimensions, dimensions, dimensions );
				
				temptation.x = spawnX;
				temptation.y = spawnY;
				
				addChild(temptation);
				temptation.addChild(imageTemptation);
				makeTemptation = false;
			}
		}
				
		public function rotateAroundMiddle():void
		{			
			var rad:Number = angle * (Math.PI / 180);
			
			ship.x = middleObject.x + radius * Math.cos(rad);
			ship.y = middleObject.y + radius * Math.sin(rad);
			
			imagePlayer.x = middleObject.x + radius * Math.cos(rad);
			imagePlayer.y = middleObject.y + radius * Math.sin(rad);
			
			if(clockWise)
				angle += speed;
			else
				angle -= speed;
			
			//ship.rotation = (Math.atan2(ship.y - middleObject.y, ship.x - middleObject.x) * 180 / Math.PI);
			//imagePlayer.rotation = (Math.atan2(imagePlayer.y - middleObject.y, imagePlayer.x - middleObject.x) * 180 / Math.PI);
		}
		
		public function rotateMainStar():void
		{			
			var rad:Number = starAngle * (Math.PI / 180);
			
			mainStar.x = middleObject.x + 350 * Math.sin(rad);
			mainStar.y = (middleObject.y + 50) + 250 * Math.cos(rad);
			
			starAngle -= .07;
			
			mainStar.rotation = (Math.atan2(mainStar.y - middleObject.y, mainStar.x - middleObject.x) * 180 / Math.PI);
		}
		
		public function resizeMe(mc:MovieClip, maxW:Number, maxH:Number = 0, constrainProportions:Boolean = true):void
		{
			mc.width = maxW;
			mc.height = maxH;
		}
		
		public function randomFromRanges(a:Array):Number
		{
			var sum:Number = 0, bound:int = a.length - 1
			
			for (var i:int = 0; i <= bound; i++)
				sum += a[i][1] - a[i][0]
			
			var num:Number = Math.random() * sum + a[0][0]
			
			for (i = 0; i < bound; i++) if (num < a[i][1])
				return num else num += a[i + 1][0] - a[i][1]
			
			return num;
		}
		
		/*//This is a tad unnecessary, but kids like displays, not text
		public function makeLeftCircle():void
		{
			displayHolderLeft = new Sprite();
			addChild(displayHolderLeft);
			
			var dimensions:int = 8;
			displayObject = new MovieClip();	
			displayObject.graphics.lineStyle(3, 0x33FF00);
			//displayObject.graphics.beginFill (0x33FF00,3);
			displayObject.graphics.drawCircle( dimensions, dimensions, dimensions );
			displayObject.x = 90;
			displayObject.y = 80;
			displayHolderLeft.addChild(displayObject);
			
			//Inside Circle
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(4, 0x000000, 1);
			displayObject.graphics.beginFill(0x000000, 1);
			displayObject.graphics.moveTo(0, 0); 
			displayObject.graphics.lineTo(20, 20);
			displayObject.graphics.lineTo(20, 10);
			displayObject.graphics.lineTo(40, 10);
			displayObject.graphics.lineTo(40, -10);
			displayObject.graphics.lineTo(20, -10);
			displayObject.graphics.lineTo(20, -20);
			displayObject.height = 30;
			displayObject.width = 60;
			displayObject.x = 150;
			displayObject.y = 150;
			displayHolderLeft.addChild(displayObject);
			
			//Left
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(4, 0x00FF00, 1);
			displayObject.graphics.beginFill(0x00FF00, 1);
			displayObject.graphics.moveTo(0, 0); 
			displayObject.graphics.lineTo(20, 20);
			displayObject.graphics.lineTo(20, 10);
			displayObject.graphics.lineTo(40, 10);
			displayObject.graphics.lineTo(40, -10);
			displayObject.graphics.lineTo(20, -10);
			displayObject.graphics.lineTo(20, -20);
			displayObject.height = 20;
			displayObject.width = 60;
			displayObject.x = 75;
			displayObject.y = 175;
			displayObject.rotation = -90;
			displayHolderLeft.addChild(displayObject);
			
			//Bottom
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(4, 0x00FF00, 1);
			displayObject.graphics.beginFill(0x00FF00, 1);
			displayObject.graphics.moveTo(0, 0); 
			displayObject.graphics.lineTo(20, 20);
			displayObject.graphics.lineTo(20, 10);
			displayObject.graphics.lineTo(40, 10);
			displayObject.graphics.lineTo(40, -10);
			displayObject.graphics.lineTo(20, -10);
			displayObject.graphics.lineTo(20, -20);
			displayObject.height = 20;
			displayObject.width = 60;
			displayObject.x = 200;
			displayObject.y = 250;
			displayObject.rotation = -180;
			displayHolderLeft.addChild(displayObject);
			
			//Right
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(4, 0x00FF00, 1);
			displayObject.graphics.beginFill(0x00FF00, 1);
			displayObject.graphics.moveTo(0, 0); 
			displayObject.graphics.lineTo(20, 20);
			displayObject.graphics.lineTo(20, 10);
			displayObject.graphics.lineTo(40, 10);
			displayObject.graphics.lineTo(40, -10);
			displayObject.graphics.lineTo(20, -10);
			displayObject.graphics.lineTo(20, -20);
			displayObject.height = 20;
			displayObject.width = 60;
			displayObject.x = 275;
			displayObject.y = 125;
			displayObject.rotation = 90;
			displayHolderLeft.addChild(displayObject);
			
			//Top
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(4, 0x00FF00, 1);
			displayObject.graphics.beginFill(0x00FF00, 1);
			displayObject.graphics.moveTo(0, 0); 
			displayObject.graphics.lineTo(20, 20);
			displayObject.graphics.lineTo(20, 10);
			displayObject.graphics.lineTo(40, 10);
			displayObject.graphics.lineTo(40, -10);
			displayObject.graphics.lineTo(20, -10);
			displayObject.graphics.lineTo(20, -20);
			displayObject.height = 20;
			displayObject.width = 60;
			displayObject.x = 140;
			displayObject.y = 50;
			displayHolderLeft.addChild(displayObject);
			
			displayObject = new MovieClip();
			dimensions = 100;
			displayObject.graphics.lineStyle(3, 0xCCFFFF);
			displayObject.graphics.beginFill(0x000000, 0);
			displayObject.graphics.drawCircle( dimensions, dimensions, dimensions );
			displayObject.x = 75;
			displayObject.y = 50;
			displayHolderLeft.addChild(displayObject);
		}
		
		public function makeRightCircle():void
		{		
			displayHolderRight = new Sprite();
			addChild(displayHolderRight);
			
			var dimensions:int = 8;
			displayObject = new MovieClip();			
			displayObject.graphics.lineStyle(3, 0x33FF00);
			//displayObject.graphics.beginFill (0x33FF00,3);
			displayObject.graphics.drawCircle( dimensions, dimensions, dimensions );
			displayObject.x = 690;
			displayObject.y = 80;
			displayHolderLeft.addChild(displayObject);
			
			//Inside Circle
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(4, 0x000000, 1);
			displayObject.graphics.beginFill(0x000000, 1);
			displayObject.graphics.moveTo(0, 0); 
			displayObject.graphics.lineTo(20, 20);
			displayObject.graphics.lineTo(20, 10);
			displayObject.graphics.lineTo(40, 10);
			displayObject.graphics.lineTo(40, -10);
			displayObject.graphics.lineTo(20, -10);
			displayObject.graphics.lineTo(20, -20);
			displayObject.height = 30;
			displayObject.width = 60;
			displayObject.x = 650;
			displayObject.y = 150;
			displayObject.rotation = 180;
			displayHolderRight.addChild(displayObject);
			
			//Left
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(4, 0x00FF00, 1);
			displayObject.graphics.beginFill(0x00FF00, 1);
			displayObject.graphics.moveTo(0, 0); 
			displayObject.graphics.lineTo(20, 20);
			displayObject.graphics.lineTo(20, 10);
			displayObject.graphics.lineTo(40, 10);
			displayObject.graphics.lineTo(40, -10);
			displayObject.graphics.lineTo(20, -10);
			displayObject.graphics.lineTo(20, -20);
			displayObject.height = 20;
			displayObject.width = 60;
			displayObject.x = 525;
			displayObject.y = 125;
			displayObject.rotation = 90;
			displayHolderRight.addChild(displayObject);
			
			//Bottom
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(4, 0x00FF00, 1);
			displayObject.graphics.beginFill(0x00FF00, 1);
			displayObject.graphics.moveTo(0, 0); 
			displayObject.graphics.lineTo(20, 20);
			displayObject.graphics.lineTo(20, 10);
			displayObject.graphics.lineTo(40, 10);
			displayObject.graphics.lineTo(40, -10);
			displayObject.graphics.lineTo(20, -10);
			displayObject.graphics.lineTo(20, -20);
			displayObject.height = 20;
			displayObject.width = 60;
			displayObject.x = 590;
			displayObject.y = 250;
			displayHolderRight.addChild(displayObject);
			
			//Right
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(4, 0x00FF00, 1);
			displayObject.graphics.beginFill(0x00FF00, 1);
			displayObject.graphics.moveTo(0, 0); 
			displayObject.graphics.lineTo(20, 20);
			displayObject.graphics.lineTo(20, 10);
			displayObject.graphics.lineTo(40, 10);
			displayObject.graphics.lineTo(40, -10);
			displayObject.graphics.lineTo(20, -10);
			displayObject.graphics.lineTo(20, -20);
			displayObject.height = 20;
			displayObject.width = 60;
			displayObject.x = 720;
			displayObject.y = 170;
			displayObject.rotation = -90;
			displayHolderRight.addChild(displayObject);
			
			//Top
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(4, 0x00FF00, 1);
			displayObject.graphics.beginFill(0x00FF00, 1);
			displayObject.graphics.moveTo(0, 0); 
			displayObject.graphics.lineTo(20, 20);
			displayObject.graphics.lineTo(20, 10);
			displayObject.graphics.lineTo(40, 10);
			displayObject.graphics.lineTo(40, -10);
			displayObject.graphics.lineTo(20, -10);
			displayObject.graphics.lineTo(20, -20);
			displayObject.height = 20;
			displayObject.width = 60;
			displayObject.x = 650;
			displayObject.y = 50;
			displayObject.rotation = 180;
			displayHolderRight.addChild(displayObject);
			
			displayObject = new MovieClip();
			dimensions = 100;
			displayObject.graphics.lineStyle(3, 0xCCFFFF);
			displayObject.graphics.beginFill(0x000000, 0);
			displayObject.graphics.drawCircle( dimensions, dimensions, dimensions );
			displayObject.x = 520;
			displayObject.y = 50;
			displayHolderRight.addChild(displayObject);
		}
		
		public function makeBotLeftCircle():void
		{
			displayHolderBotLeft = new Sprite();
			addChild(displayHolderBotLeft);
			
			var dimensions:int = 8;
			displayObject = new MovieClip();			
			displayObject.graphics.lineStyle(3, 0x33FF00);
			//displayObject.graphics.beginFill (0x33FF00,3);
			displayObject.graphics.drawCircle( dimensions, dimensions, dimensions );
			displayObject.x = 90;
			displayObject.y = 380;
			displayHolderLeft.addChild(displayObject);
			
			
			//Inside Circle Up
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(4, 0x000000, 1);
			displayObject.graphics.beginFill(0x000000, 1);
			displayObject.graphics.moveTo(0, 0); 
			displayObject.graphics.lineTo(20, 20);
			displayObject.graphics.lineTo(20, 10);
			displayObject.graphics.lineTo(40, 10);
			displayObject.graphics.lineTo(40, -10);
			displayObject.graphics.lineTo(20, -10);
			displayObject.graphics.lineTo(20, -20);
			displayObject.height = 30;
			displayObject.width = 60;
			displayObject.x = 150;
			displayObject.y = 425;
			displayObject.rotation = 90;
			displayHolderBotLeft.addChild(displayObject);
			
			//Inside Circle Down
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(4, 0x000000, 1);
			displayObject.graphics.beginFill(0x000000, 1);
			displayObject.graphics.moveTo(0, 0); 
			displayObject.graphics.lineTo(20, 20);
			displayObject.graphics.lineTo(20, 10);
			displayObject.graphics.lineTo(40, 10);
			displayObject.graphics.lineTo(40, -10);
			displayObject.graphics.lineTo(20, -10);
			displayObject.graphics.lineTo(20, -20);
			displayObject.height = 30;
			displayObject.width = 60;
			displayObject.x = 200;
			displayObject.y = 480;
			displayObject.rotation = -90;
			displayHolderBotLeft.addChild(displayObject);
			
			displayObject = new MovieClip();
			dimensions = 100;
			displayObject.graphics.lineStyle(3, 0xCCFFFF);
			displayObject.graphics.beginFill(0x000000, 0);
			displayObject.graphics.drawCircle( dimensions, dimensions, dimensions );
			displayObject.x = 75;
			displayObject.y = 350;
			displayHolderBotLeft.addChild(displayObject);
		}*/
		
		public function makeBotRightCircle():void
		{
			displayHolderBotRight = new Sprite();
			addChild(displayHolderBotRight);
			
			var dimensions:int = 8;
			
			//Make display for collectibles
			displayObject = new MovieClip();
			displayObject.graphics.beginFill(0x0066CC, 1);
			displayObject.graphics.drawRect(0, 0, 720, 520);
			displayObject.x = 40;
			displayObject.y = 40;
			displayHolderBotRight.addChild(displayObject);
			
			myFormat.size = 22;
			myFormat.align = TextFormatAlign.LEFT;
			
			displayText = new TextField();
			displayText.defaultTextFormat = myFormat;
			displayText.textColor = 0x00DF00;
			displayText.x = 50;
			displayText.y = 100;
			displayText.width = 700;
			displayText.height = 800;
			displayText.text = "Collect the smiley faces \n		while avoiding the tempting cupcakes and the daily chores."
			+ "\n\nDon't let your energy fall to zero and make sure your lantern stays lit."
			+ "\n\nYou can get more energy by eating a cupcake.\nBut eating a cupcake is giving into temptation."
			+ "\n\nWhen you give into temptation, your lantern will grow darker."
			+ "\n\nTo gain more spirituality and make your lantern brighter,\n	do a good deed by collecting a smiley face."
			+ "\n\nEvery so often the player will be awarded with a shield that stops all chores."
			+ "\n\nUse the arrow keys to control the players movement.";
			displayHolderBotRight.addChild(displayText);
			
			myFormat.size = 25;
			displayText = new TextField();
			displayText.defaultTextFormat = myFormat;
			displayText.textColor = 0x00FF00;
			displayText.background = true; 
			displayText.backgroundColor = 0x333333;
			displayText.width = 200;
			displayText.height = 35;
			displayText.x = 300;
			displayText.y = 50;
			displayText.text = "As Simple As That";
			displayHolderBotRight.addChild(displayText);
			
			myFormat.size = 25;
			displayText = new TextField();
			displayText.defaultTextFormat = myFormat;
			displayText.textColor = 0x00FF00;
			displayText.background = true; 
			displayText.backgroundColor = 0x333333;
			displayText.width = 200;
			displayText.height = 35;
			displayText.x = 300;
			displayText.y = 515;
			displayText.text = "Click Here To Start";
			displayHolderBotRight.addChild(displayText);
			
			
			//Player
			/*displayObject = new MovieClip();
			dimensions = 8;
			displayObject.graphics.lineStyle(3, 0x33FF00);
			//displayObject.graphics.beginFill (0x33FF00,3);
			displayObject.graphics.drawCircle( dimensions, dimensions, dimensions );
			displayObject.x = 495;
			displayObject.y = 350;
			displayHolderBotRight.addChild(displayObject);
			
			//Health/Temptation
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(2, 0xFF0000);
			displayObject.graphics.beginFill(0xFF0000, 2);
			drawStar(displayObject.graphics, 0, 0, 6, 8, 10, 0);
			displayObject.x = 580;
			displayObject.y = 360;
			displayHolderBotRight.addChild(displayObject);
			
			//Points/Deed
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(2, 0xFF00FF);
			displayObject.graphics.beginFill(0xFF00FF, 2);
			drawStar(displayObject.graphics, 0, 0, 5, 5, 12, 20);
			displayObject.x = 610;
			displayObject.y = 360;
			displayHolderBotRight.addChild(displayObject);
			
			//Arrrow
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(4, 0x000000, 1);
			displayObject.graphics.beginFill(0x000000, 1);
			displayObject.graphics.moveTo(0, 0); 
			displayObject.graphics.lineTo(20, 20);
			displayObject.graphics.lineTo(20, 10);
			displayObject.graphics.lineTo(40, 10);
			displayObject.graphics.lineTo(40, -10);
			displayObject.graphics.lineTo(20, -10);
			displayObject.graphics.lineTo(20, -20);
			displayObject.height = 10;
			displayObject.width = 40;
			displayObject.x = 560;
			displayObject.y = 360;
			displayObject.rotation = 180;
			displayHolderBotRight.addChild(displayObject);
			
			//Health/Temptation to bar
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(2, 0xFF0000);
			displayObject.graphics.beginFill(0xFF0000, 2);
			drawStar(displayObject.graphics, 0, 0, 6, 8, 10, 0);
			displayObject.x = 500;
			displayObject.y = 390;
			displayHolderBotRight.addChild(displayObject);
			
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(4, 0x000000, 1);
			displayObject.graphics.beginFill(0x000000, 1);
			displayObject.graphics.moveTo(0, 0); 
			displayObject.graphics.lineTo(20, 20);
			displayObject.graphics.lineTo(20, 10);
			displayObject.graphics.lineTo(40, 10);
			displayObject.graphics.lineTo(40, -10);
			displayObject.graphics.lineTo(20, -10);
			displayObject.graphics.lineTo(20, -20);
			displayObject.height = 10;
			displayObject.width = 40;
			displayObject.x = 560;
			displayObject.y = 390;
			displayObject.rotation = 180;
			displayHolderBotRight.addChild(displayObject);
			
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(3, 0xFF00FF);
			displayObject.graphics.beginFill(0x000000, 0);
			displayObject.graphics.drawRect(0, 0, 53, 13);
			displayObject.x = 608;
			displayObject.y = 383;
			displayHolderBotRight.addChild(displayObject);
			
			displayObject = new MovieClip();
			colors = [0x0000FF, 0xFF00FF];
			matr.createGradientBox(50, 10, 0, 0, 0);
			displayObject.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);        
			displayObject.graphics.drawRect(0, 0, 50, 10);
			displayObject.x = 610;
			displayObject.y = 385;
			displayHolderBotRight.addChild(displayObject);
			
			//Points/Deed to bar
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(2, 0xFF00FF);
			displayObject.graphics.beginFill(0xFF00FF, 2);
			drawStar(displayObject.graphics, 0, 0, 5, 5, 12, 20);
			displayObject.x = 500;
			displayObject.y = 420;
			displayHolderBotRight.addChild(displayObject);
			
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(4, 0x000000, 1);
			displayObject.graphics.beginFill(0x000000, 1);
			displayObject.graphics.moveTo(0, 0); 
			displayObject.graphics.lineTo(20, 20);
			displayObject.graphics.lineTo(20, 10);
			displayObject.graphics.lineTo(40, 10);
			displayObject.graphics.lineTo(40, -10);
			displayObject.graphics.lineTo(20, -10);
			displayObject.graphics.lineTo(20, -20);
			displayObject.height = 10;
			displayObject.width = 40;
			displayObject.x = 560;
			displayObject.y = 420;
			displayObject.rotation = 180;
			displayHolderBotRight.addChild(displayObject);
						
			//spiritual circle
			displayObject = new MovieClip();			
			dimensions = 9;
			displayObject.graphics.beginFill (0xFFCC00,3);
			displayObject.graphics.drawCircle( dimensions, dimensions, dimensions );
			displayObject.x = 570;
			displayObject.y = 380;
			displayHolderBotRight.addChild(displayObject);
			
			displayObject = new MovieClip();			
			dimensions = 9;
			displayObject.graphics.beginFill (0xFFCC00,3);
			displayObject.graphics.drawCircle( dimensions, dimensions, dimensions );
			displayObject.x = 570;
			displayObject.y = 410;
			displayHolderBotRight.addChild(displayObject);
			
			//Enemy and player
			displayObject = new MovieClip();			
			displayObject.graphics.lineStyle(3, 0x33FF00);
			displayObject.graphics.drawCircle( dimensions, dimensions, dimensions );
			displayObject.x = 495;
			displayObject.y = 485;
			displayHolderBotRight.addChild(displayObject);
			
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(4, 0x000000, 1);
			displayObject.graphics.beginFill(0x000000, 1);
			displayObject.graphics.moveTo(0, 0); 
			displayObject.graphics.lineTo(20, 20);
			displayObject.graphics.lineTo(20, 10);
			displayObject.graphics.lineTo(40, 10);
			displayObject.graphics.lineTo(40, -10);
			displayObject.graphics.lineTo(20, -10);
			displayObject.graphics.lineTo(20, -20);
			displayObject.height = 10;
			displayObject.width = 40;
			displayObject.x = 530;
			displayObject.y = 490;
			displayObject.rotation = 0;
			displayHolderBotRight.addChild(displayObject);
			
			displayObject = new MovieClip();
			displayObject.graphics.lineStyle(5, 0xFF0000, 4);
			displayObject.graphics.moveTo(0, 0); 
			displayObject.graphics.lineTo(25, -25);
			displayObject.graphics.lineTo(45, 0);
			displayObject.graphics.lineTo(0, 0);
			displayObject.width = 30;
			displayObject.height = 30;
			displayObject.x = 580;
			displayObject.y = 490;
			displayObject.rotation = 30;
			displayHolderBotRight.addChild(displayObject);*/
		}
		
		public function drawStar(target:Graphics, x:Number, y:Number, points:uint, innerRadius:Number, outerRadius:Number, angle:Number=0):void
		{
			var step:Number, halfStep:Number, start:Number, n:Number, dx:Number, dy:Number;
			
			step = (Math.PI * 2) / points;
			halfStep = step / 2;
			
			start = (angle / 180) * Math.PI;
			target.moveTo(x + (Math.cos(start) * outerRadius), y - (Math.sin(start) * outerRadius));
			
			for (n = 1; n <= points; ++n)
			{
				dx = x + Math.cos(start + (step * n) - halfStep) * innerRadius;
				dy = y - Math.sin(start + (step * n) - halfStep) * innerRadius;
				
				target.lineTo(dx, dy);
				
				dx = x + Math.cos(start + (step * n)) * outerRadius;
				dy = y - Math.sin(start + (step * n)) * outerRadius;
				
				target.lineTo(dx, dy);
			}
		}
	}
}