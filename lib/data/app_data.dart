import '../models/models.dart';

class AppData {
  static const profiles = [
    LearnerProfile('child1', 'ילד 1', '👦'),
    LearnerProfile('child2', 'ילד 2', '👧'),
    LearnerProfile('dad', 'אבא', '👨'),
    LearnerProfile('mom', 'אמא', '👩'),
  ];

  static const worlds = [
    World(1, 'First Words', '🔤', 'קוראים מילים ראשונות'),
    World(2, 'I See', '👀', 'I see a dog.'),
    World(3, 'Colors', '🎨', 'I see a red dog.'),
    World(4, 'About Me', '😀', 'I am happy.'),
    World(5, 'People', '👦', 'They are happy.'),
    World(6, 'Family', '👨‍👩‍👧', 'This is my mom.'),
    World(7, 'Food', '🍕', 'I like pizza.'),
    World(8, 'Numbers', '🔢', 'She has two cats.'),
    World(9, 'Actions', '🏃', 'They can run.'),
    World(10, 'My Things', '🏠', 'My book is on the table.'),
    World(11, 'Where?', '📍', 'The ball is under the table.'),
    World(12, "Let's Talk", '💬', 'מבחן הבנה משולב'),
    World(13, 'My Body', '🧍', 'This is my head.'),
    World(14, 'Clothes', '👕', 'I wear a red shirt.'),
    World(15, 'School', '🏫', 'I go to school.'),
    World(16, 'Home', '🚪', 'My bed is in my room.'),
    World(17, 'My Day', '⏰', 'I wake up in the morning.'),
    World(18, 'More Actions', '🤝', 'Can you help me?'),
    World(19, 'Feelings', '😊', 'I feel happy today.'),
    World(20, 'Weather', '☀️', 'It is sunny today.'),
    World(21, 'Places', '🏙️', 'I go to the park.'),
    World(22, 'Time', '🕒', 'See you tomorrow.'),
    World(23, 'Questions', '❓', 'Why are you happy?'),
    World(24, "Let's Read", '📖', 'I think I know the answer.'),
  ];

  static const words = <VocabWord>[
    VocabWord(id:'cat', english:'cat', hebrew:'חתול', category:'animals', world:1, phonics:['c','a','t'], examples:['a cat','I see a cat.']),
    VocabWord(id:'dog', english:'dog', hebrew:'כלב', category:'animals', world:1, phonics:['d','o','g'], examples:['a dog','I see a dog.','The dog is big.']),
    VocabWord(id:'pig', english:'pig', hebrew:'חזיר', category:'animals', world:1, phonics:['p','i','g']),
    VocabWord(id:'fish', english:'fish', hebrew:'דג', category:'animals', world:1, phonics:['f','i','sh']),
    VocabWord(id:'bird', english:'bird', hebrew:'ציפור', category:'animals', world:1),
    VocabWord(id:'frog', english:'frog', hebrew:'צפרדע', category:'animals', world:1),
    VocabWord(id:'duck', english:'duck', hebrew:'ברווז', category:'animals', world:1, phonics:['d','u','ck']),
    VocabWord(id:'rabbit', english:'rabbit', hebrew:'ארנב', category:'animals', world:1),
    VocabWord(id:'horse', english:'horse', hebrew:'סוס', category:'animals', world:2),
    VocabWord(id:'cow', english:'cow', hebrew:'פרה', category:'animals', world:2),

    VocabWord(id:'i', english:'I', hebrew:'אני', category:'structure', world:2, explanation:"אני קוראים ל-I כשמדברים על עצמנו, כמו המילה 'אני' בעברית. שימו לב: תמיד כותבים אותה באות גדולה!"),
    VocabWord(id:'see', english:'see', hebrew:'רואה/רואה', category:'verbs', world:2, phonics:['s','ee']),
    VocabWord(id:'a', english:'a', hebrew:'אחד/אחת', category:'structure', world:2, explanation:"המילה a באה לפני שם עצם יחיד, כשמדברים על משהו אחד, לא ספציפי. למשל: a dog — כלב אחד (איזה שהוא כלב)."),
    VocabWord(id:'an', english:'an', hebrew:'אחד/אחת', category:'structure', world:7, explanation:"an זהה בתפקידו ל-a, אבל משתמשים בו כשהמילה שאחריו מתחילה בצליל תנועה. למשל: an apple."),
    VocabWord(id:'this', english:'this', hebrew:'זה/זאת', category:'structure', world:2, explanation:"this משמשים כשמצביעים על משהו קרוב אלינו. למשל: this dog — הכלב הזה (שנמצא כאן)."),
    VocabWord(id:'that', english:'that', hebrew:'ההוא/ההיא', category:'structure', world:2, explanation:"that משמשים כשמצביעים על משהו רחוק מאיתנו. למשל: that dog — הכלב ההוא (שנמצא שם)."),
    VocabWord(id:'is', english:'is', hebrew:'הוא/היא', category:'be', world:2, explanation:"is היא מילת קישור שמחברת בין נושא יחיד (הוא/היא/זה) לתיאור שלו. למשל: The dog is big — הכלב הוא גדול."),

    VocabWord(id:'red', english:'red', hebrew:'אדום', category:'colors', world:3),
    VocabWord(id:'blue', english:'blue', hebrew:'כחול', category:'colors', world:3),
    VocabWord(id:'green', english:'green', hebrew:'ירוק', category:'colors', world:3),
    VocabWord(id:'yellow', english:'yellow', hebrew:'צהוב', category:'colors', world:3),
    VocabWord(id:'black', english:'black', hebrew:'שחור', category:'colors', world:3),
    VocabWord(id:'white', english:'white', hebrew:'לבן', category:'colors', world:3),
    VocabWord(id:'pink', english:'pink', hebrew:'ורוד', category:'colors', world:3),
    VocabWord(id:'orange', english:'orange', hebrew:'כתום', category:'colors', world:3),

    VocabWord(id:'am', english:'am', hebrew:'הנני/אני', category:'be', world:4, explanation:"am היא מילת הקישור שמשתמשים בה רק עם I. למשל: I am happy — אני שמח."),
    VocabWord(id:'happy', english:'happy', hebrew:'שמח', category:'adjectives', world:4),
    VocabWord(id:'sad', english:'sad', hebrew:'עצוב', category:'adjectives', world:4),
    VocabWord(id:'good', english:'good', hebrew:'טוב', category:'adjectives', world:4),
    VocabWord(id:'bad', english:'bad', hebrew:'רע', category:'adjectives', world:4),
    VocabWord(id:'big', english:'big', hebrew:'גדול', category:'adjectives', world:4),
    VocabWord(id:'small', english:'small', hebrew:'קטן', category:'adjectives', world:4),

    VocabWord(id:'you', english:'you', hebrew:'אתה/את', category:'pronouns', world:5),
    VocabWord(id:'he', english:'he', hebrew:'הוא', category:'pronouns', world:5),
    VocabWord(id:'she', english:'she', hebrew:'היא', category:'pronouns', world:5),
    VocabWord(id:'it', english:'it', hebrew:'זה/זאת', category:'pronouns', world:5),
    VocabWord(id:'we', english:'we', hebrew:'אנחנו', category:'pronouns', world:5),
    VocabWord(id:'they', english:'they', hebrew:'הם/הן', category:'pronouns', world:5),
    VocabWord(id:'are', english:'are', hebrew:'הם/הינך', category:'be', world:5, explanation:"are היא מילת הקישור שמשתמשים בה עם you, we, they, או כמה דברים ביחד. למשל: They are happy — הם שמחים."),
    VocabWord(id:'boy', english:'boy', hebrew:'ילד', category:'people', world:5),
    VocabWord(id:'girl', english:'girl', hebrew:'ילדה', category:'people', world:5),

    VocabWord(id:'mom', english:'mom', hebrew:'אמא', category:'family', world:6),
    VocabWord(id:'dad', english:'dad', hebrew:'אבא', category:'family', world:6),
    VocabWord(id:'baby', english:'baby', hebrew:'תינוק', category:'family', world:6),
    VocabWord(id:'man', english:'man', hebrew:'איש', category:'people', world:6),
    VocabWord(id:'woman', english:'woman', hebrew:'אישה', category:'people', world:6),
    VocabWord(id:'friend', english:'friend', hebrew:'חבר/חברה', category:'people', world:6),
    VocabWord(id:'my', english:'my', hebrew:'שלי', category:'structure', world:6, explanation:"my פירושו 'שלי'. למשל: my dog — הכלב שלי."),
    VocabWord(id:'your', english:'your', hebrew:'שלך', category:'structure', world:6, explanation:"your פירושו 'שלך'. למשל: your book — הספר שלך."),

    VocabWord(id:'apple', english:'apple', hebrew:'תפוח', category:'food', world:7),
    VocabWord(id:'banana', english:'banana', hebrew:'בננה', category:'food', world:7),
    VocabWord(id:'pizza', english:'pizza', hebrew:'פיצה', category:'food', world:7),
    VocabWord(id:'bread', english:'bread', hebrew:'לחם', category:'food', world:7),
    VocabWord(id:'egg', english:'egg', hebrew:'ביצה', category:'food', world:7),
    VocabWord(id:'milk', english:'milk', hebrew:'חלב', category:'food', world:7),
    VocabWord(id:'water', english:'water', hebrew:'מים', category:'food', world:7),
    VocabWord(id:'cake', english:'cake', hebrew:'עוגה', category:'food', world:7),
    VocabWord(id:'rice', english:'rice', hebrew:'אורז', category:'food', world:7),
    VocabWord(id:'cheese', english:'cheese', hebrew:'גבינה', category:'food', world:7),
    VocabWord(id:'like', english:'like', hebrew:'אוהב/אוהבת', category:'verbs', world:7),
    VocabWord(id:'eat', english:'eat', hebrew:'אוכל/אוכלת', category:'verbs', world:7),
    VocabWord(id:'drink', english:'drink', hebrew:'שותה', category:'verbs', world:7),
    VocabWord(id:'want', english:'want', hebrew:'רוצה', category:'verbs', world:7),

    VocabWord(id:'one', english:'one', hebrew:'אחת/אחד', category:'numbers', world:8),
    VocabWord(id:'two', english:'two', hebrew:'שתיים/שניים', category:'numbers', world:8),
    VocabWord(id:'three', english:'three', hebrew:'שלוש/שלושה', category:'numbers', world:8),
    VocabWord(id:'four', english:'four', hebrew:'ארבע', category:'numbers', world:8),
    VocabWord(id:'five', english:'five', hebrew:'חמש', category:'numbers', world:8),
    VocabWord(id:'six', english:'six', hebrew:'שש', category:'numbers', world:8),
    VocabWord(id:'seven', english:'seven', hebrew:'שבע', category:'numbers', world:8),
    VocabWord(id:'eight', english:'eight', hebrew:'שמונה', category:'numbers', world:8),
    VocabWord(id:'nine', english:'nine', hebrew:'תשע', category:'numbers', world:8),
    VocabWord(id:'ten', english:'ten', hebrew:'עשר', category:'numbers', world:8),
    VocabWord(id:'have', english:'have', hebrew:'יש לי/יש', category:'verbs', world:8),
    VocabWord(id:'has', english:'has', hebrew:'יש לו/לה', category:'verbs', world:8),

    VocabWord(id:'can', english:'can', hebrew:'יכול/יכולה', category:'verbs', world:9),
    VocabWord(id:'go', english:'go', hebrew:'הולך/לך', category:'verbs', world:9),
    VocabWord(id:'run', english:'run', hebrew:'רץ', category:'verbs', world:9),
    VocabWord(id:'walk', english:'walk', hebrew:'הולך', category:'verbs', world:9),
    VocabWord(id:'jump', english:'jump', hebrew:'קופץ', category:'verbs', world:9),
    VocabWord(id:'sit', english:'sit', hebrew:'שב', category:'verbs', world:9),
    VocabWord(id:'stand', english:'stand', hebrew:'עמוד', category:'verbs', world:9),
    VocabWord(id:'play', english:'play', hebrew:'משחק', category:'verbs', world:9),
    VocabWord(id:'read', english:'read', hebrew:'קורא', category:'verbs', world:9),
    VocabWord(id:'look', english:'look', hebrew:'הסתכל', category:'verbs', world:9),

    VocabWord(id:'house', english:'house', hebrew:'בית', category:'things', world:10),
    VocabWord(id:'car', english:'car', hebrew:'מכונית', category:'things', world:10),
    VocabWord(id:'bus', english:'bus', hebrew:'אוטובוס', category:'things', world:10),
    VocabWord(id:'ball', english:'ball', hebrew:'כדור', category:'things', world:10),
    VocabWord(id:'book', english:'book', hebrew:'ספר', category:'things', world:10),
    VocabWord(id:'bed', english:'bed', hebrew:'מיטה', category:'things', world:10),
    VocabWord(id:'chair', english:'chair', hebrew:'כיסא', category:'things', world:10),
    VocabWord(id:'table', english:'table', hebrew:'שולחן', category:'things', world:10),
    VocabWord(id:'door', english:'door', hebrew:'דלת', category:'things', world:10),
    VocabWord(id:'bag', english:'bag', hebrew:'תיק', category:'things', world:10),

    VocabWord(id:'where', english:'where', hebrew:'איפה', category:'questions', world:11),
    VocabWord(id:'in', english:'in', hebrew:'בתוך', category:'position', world:11),
    VocabWord(id:'on', english:'on', hebrew:'על', category:'position', world:11),
    VocabWord(id:'under', english:'under', hebrew:'מתחת', category:'position', world:11),
    VocabWord(id:'here', english:'here', hebrew:'כאן', category:'position', world:11),
    VocabWord(id:'there', english:'there', hebrew:'שם', category:'position', world:11),
    VocabWord(id:'up', english:'up', hebrew:'למעלה', category:'position', world:11),
    VocabWord(id:'down', english:'down', hebrew:'למטה', category:'position', world:11),
    VocabWord(id:'open', english:'open', hebrew:'פתח/פתוח', category:'verbs', world:11),
    VocabWord(id:'close', english:'close', hebrew:'סגור', category:'verbs', world:11),

    VocabWord(id:'what', english:'what', hebrew:'מה', category:'questions', world:12),
    VocabWord(id:'who', english:'who', hebrew:'מי', category:'questions', world:12),
    VocabWord(id:'do', english:'do', hebrew:'עושה/מילת שאלה', category:'structure', world:12, explanation:"do היא מילה שעוזרת לבנות שאלות. למשל: Do you like pizza? — האם אתה אוהב פיצה?"),
    VocabWord(id:'not', english:'not', hebrew:'לא', category:'structure', world:12, explanation:"not פירושו 'לא', ומשתמשים בו כדי לשלול משפט. למשל: I am not sad — אני לא עצוב."),
    VocabWord(id:'yes', english:'yes', hebrew:'כן', category:'answers', world:12),
    VocabWord(id:'no', english:'no', hebrew:'לא', category:'answers', world:12),
    VocabWord(id:'and', english:'and', hebrew:'ו', category:'structure', world:12, explanation:"and פירושו 'ו', ומשתמשים בו כדי לחבר בין שתי מילים או רעיונות. למשל: cat and dog — חתול וכלב."),
    VocabWord(id:'the', english:'the', hebrew:'ה־', category:'structure', world:12, explanation:"the היא מילה שבאה לפני שם עצם ספציפי וידוע. למשל: the dog — הכלב (כלב מסוים שכולם יודעים על איזה מדובר)."),
    VocabWord(id:'old', english:'old', hebrew:'ישן/מבוגר', category:'adjectives', world:12),
    VocabWord(id:'new', english:'new', hebrew:'חדש', category:'adjectives', world:12),
    VocabWord(id:'hot', english:'hot', hebrew:'חם', category:'adjectives', world:12),
    VocabWord(id:'cold', english:'cold', hebrew:'קר', category:'adjectives', world:12),
    VocabWord(id:'fast', english:'fast', hebrew:'מהיר', category:'adjectives', world:12),
    VocabWord(id:'slow', english:'slow', hebrew:'איטי', category:'adjectives', world:12),

    // World 13 — My Body
    VocabWord(id:'head', english:'head', hebrew:'ראש', category:'body', world:13),
    VocabWord(id:'hand', english:'hand', hebrew:'יד', category:'body', world:13),
    VocabWord(id:'leg', english:'leg', hebrew:'רגל', category:'body', world:13),
    VocabWord(id:'foot', english:'foot', hebrew:'כף רגל', category:'body', world:13),
    VocabWord(id:'eye', english:'eye', hebrew:'עין', category:'body', world:13),
    VocabWord(id:'ear', english:'ear', hebrew:'אוזן', category:'body', world:13),
    VocabWord(id:'nose', english:'nose', hebrew:'אף', category:'body', world:13),
    VocabWord(id:'mouth', english:'mouth', hebrew:'פה', category:'body', world:13),
    VocabWord(id:'hair', english:'hair', hebrew:'שיער', category:'body', world:13),
    VocabWord(id:'face', english:'face', hebrew:'פנים', category:'body', world:13),

    // World 14 — Clothes
    VocabWord(id:'shirt', english:'shirt', hebrew:'חולצה', category:'clothes', world:14),
    VocabWord(id:'pants', english:'pants', hebrew:'מכנסיים', category:'clothes', world:14),
    VocabWord(id:'shoes', english:'shoes', hebrew:'נעליים', category:'clothes', world:14),
    VocabWord(id:'socks', english:'socks', hebrew:'גרביים', category:'clothes', world:14),
    VocabWord(id:'dress', english:'dress', hebrew:'שמלה', category:'clothes', world:14),
    VocabWord(id:'hat', english:'hat', hebrew:'כובע', category:'clothes', world:14),
    VocabWord(id:'coat', english:'coat', hebrew:'מעיל', category:'clothes', world:14),
    VocabWord(id:'shorts', english:'shorts', hebrew:'מכנסיים קצרים', category:'clothes', world:14),
    VocabWord(id:'wear', english:'wear', hebrew:'לובש/לובשת', category:'verbs', world:14),
    VocabWord(id:'clothes', english:'clothes', hebrew:'בגדים', category:'clothes', world:14),

    // World 15 — School
    VocabWord(id:'school', english:'school', hebrew:'בית ספר', category:'school', world:15),
    VocabWord(id:'teacher', english:'teacher', hebrew:'מורה', category:'school', world:15),
    VocabWord(id:'class', english:'class', hebrew:'כיתה', category:'school', world:15),
    VocabWord(id:'pen', english:'pen', hebrew:'עט', category:'school', world:15),
    VocabWord(id:'pencil', english:'pencil', hebrew:'עיפרון', category:'school', world:15),
    VocabWord(id:'paper', english:'paper', hebrew:'נייר', category:'school', world:15),
    VocabWord(id:'desk', english:'desk', hebrew:'שולחן כתיבה', category:'school', world:15),
    VocabWord(id:'write', english:'write', hebrew:'כותב/כותבת', category:'verbs', world:15),
    VocabWord(id:'learn', english:'learn', hebrew:'לומד/לומדת', category:'verbs', world:15),
    VocabWord(id:'student', english:'student', hebrew:'תלמיד/ה', category:'school', world:15),

    // World 16 — Home
    VocabWord(id:'room', english:'room', hebrew:'חדר', category:'home', world:16),
    VocabWord(id:'kitchen', english:'kitchen', hebrew:'מטבח', category:'home', world:16),
    VocabWord(id:'bathroom', english:'bathroom', hebrew:'חדר אמבטיה', category:'home', world:16),
    VocabWord(id:'bedroom', english:'bedroom', hebrew:'חדר שינה', category:'home', world:16),
    VocabWord(id:'window', english:'window', hebrew:'חלון', category:'home', world:16),
    VocabWord(id:'floor', english:'floor', hebrew:'רצפה', category:'home', world:16),
    VocabWord(id:'wall', english:'wall', hebrew:'קיר', category:'home', world:16),
    VocabWord(id:'light', english:'light', hebrew:'אור', category:'home', world:16),
    VocabWord(id:'inside', english:'inside', hebrew:'בפנים', category:'position', world:16),
    VocabWord(id:'outside', english:'outside', hebrew:'בחוץ', category:'position', world:16),

    // World 17 — My Day
    VocabWord(id:'morning', english:'morning', hebrew:'בוקר', category:'time', world:17),
    VocabWord(id:'night', english:'night', hebrew:'לילה', category:'time', world:17),
    VocabWord(id:'wake', english:'wake', hebrew:'מתעורר/ת', category:'verbs', world:17),
    VocabWord(id:'sleep', english:'sleep', hebrew:'ישן/ה', category:'verbs', world:17),
    VocabWord(id:'wash', english:'wash', hebrew:'שוטף/שוטפת', category:'verbs', world:17),
    VocabWord(id:'start', english:'start', hebrew:'מתחיל/ה', category:'verbs', world:17),
    VocabWord(id:'finish', english:'finish', hebrew:'מסיים/ת', category:'verbs', world:17),
    VocabWord(id:'today', english:'today', hebrew:'היום', category:'time', world:17),
    VocabWord(id:'now', english:'now', hebrew:'עכשיו', category:'time', world:17),
    VocabWord(id:'later', english:'later', hebrew:'אחר כך', category:'time', world:17),

    // World 18 — More Actions
    VocabWord(id:'come', english:'come', hebrew:'בוא/מגיע', category:'verbs', world:18),
    VocabWord(id:'give', english:'give', hebrew:'נותן/נותנת', category:'verbs', world:18),
    VocabWord(id:'take', english:'take', hebrew:'לוקח/ת', category:'verbs', world:18),
    VocabWord(id:'make', english:'make', hebrew:'עושה/מכין', category:'verbs', world:18),
    VocabWord(id:'help', english:'help', hebrew:'עוזר/ת', category:'verbs', world:18),
    VocabWord(id:'stop', english:'stop', hebrew:'עוצר/ת', category:'verbs', world:18),
    VocabWord(id:'put', english:'put', hebrew:'שם/מניח', category:'verbs', world:18),
    VocabWord(id:'get', english:'get', hebrew:'מקבל/ת', category:'verbs', world:18),
    VocabWord(id:'say', english:'say', hebrew:'אומר/ת', category:'verbs', world:18),
    VocabWord(id:'listen', english:'listen', hebrew:'מקשיב/ה', category:'verbs', world:18),

    // World 19 — Feelings
    VocabWord(id:'angry', english:'angry', hebrew:'כועס/ת', category:'feelings', world:19),
    VocabWord(id:'tired', english:'tired', hebrew:'עייף/ה', category:'feelings', world:19),
    VocabWord(id:'hungry', english:'hungry', hebrew:'רעב/ה', category:'feelings', world:19),
    VocabWord(id:'thirsty', english:'thirsty', hebrew:'צמא/ה', category:'feelings', world:19),
    VocabWord(id:'scared', english:'scared', hebrew:'מפוחד/ת', category:'feelings', world:19),
    VocabWord(id:'funny', english:'funny', hebrew:'מצחיק/ה', category:'feelings', world:19),
    VocabWord(id:'nice', english:'nice', hebrew:'נחמד/ה', category:'feelings', world:19),
    VocabWord(id:'okay', english:'okay', hebrew:'בסדר', category:'feelings', world:19),
    VocabWord(id:'love', english:'love', hebrew:'אוהב/ת מאוד', category:'feelings', world:19),
    VocabWord(id:'feel', english:'feel', hebrew:'מרגיש/ה', category:'feelings', world:19),

    // World 20 — Weather
    VocabWord(id:'sun', english:'sun', hebrew:'שמש', category:'weather', world:20),
    VocabWord(id:'rain', english:'rain', hebrew:'גשם', category:'weather', world:20),
    VocabWord(id:'cloud', english:'cloud', hebrew:'ענן', category:'weather', world:20),
    VocabWord(id:'wind', english:'wind', hebrew:'רוח', category:'weather', world:20),
    VocabWord(id:'sky', english:'sky', hebrew:'שמיים', category:'weather', world:20),
    VocabWord(id:'sunny', english:'sunny', hebrew:'שמשי', category:'adjectives', world:20),
    VocabWord(id:'rainy', english:'rainy', hebrew:'גשום', category:'adjectives', world:20),
    VocabWord(id:'warm', english:'warm', hebrew:'חמים', category:'adjectives', world:20),
    VocabWord(id:'weather', english:'weather', hebrew:'מזג אוויר', category:'weather', world:20),
    VocabWord(id:'storm', english:'storm', hebrew:'סערה', category:'weather', world:20),

    // World 21 — Places
    VocabWord(id:'park', english:'park', hebrew:'פארק', category:'places', world:21),
    VocabWord(id:'store', english:'store', hebrew:'חנות', category:'places', world:21),
    VocabWord(id:'street', english:'street', hebrew:'רחוב', category:'places', world:21),
    VocabWord(id:'city', english:'city', hebrew:'עיר', category:'places', world:21),
    VocabWord(id:'beach', english:'beach', hebrew:'חוף', category:'places', world:21),
    VocabWord(id:'sea', english:'sea', hebrew:'ים', category:'places', world:21),
    VocabWord(id:'road', english:'road', hebrew:'כביש', category:'places', world:21),
    VocabWord(id:'home', english:'home', hebrew:'בית (מקום מגורים)', category:'places', world:21),
    VocabWord(id:'shop', english:'shop', hebrew:'חנות', category:'places', world:21),
    VocabWord(id:'place', english:'place', hebrew:'מקום', category:'places', world:21),

    // World 22 — Time
    VocabWord(id:'day', english:'day', hebrew:'יום', category:'time', world:22),
    VocabWord(id:'week', english:'week', hebrew:'שבוע', category:'time', world:22),
    VocabWord(id:'hour', english:'hour', hebrew:'שעה', category:'time', world:22),
    VocabWord(id:'minute', english:'minute', hebrew:'דקה', category:'time', world:22),
    VocabWord(id:'before', english:'before', hebrew:'לפני', category:'time', world:22),
    VocabWord(id:'after', english:'after', hebrew:'אחרי', category:'time', world:22),
    VocabWord(id:'early', english:'early', hebrew:'מוקדם', category:'time', world:22),
    VocabWord(id:'late', english:'late', hebrew:'מאוחר', category:'time', world:22),
    VocabWord(id:'yesterday', english:'yesterday', hebrew:'אתמול', category:'time', world:22),
    VocabWord(id:'tomorrow', english:'tomorrow', hebrew:'מחר', category:'time', world:22),

    // World 23 — Questions & advanced connectors (all get explanations —
    // these are exactly the kind of function words that don't translate
    // cleanly to a single Hebrew word).
    VocabWord(id:'when', english:'when', hebrew:'מתי', category:'questions', world:23, explanation:'when פירושו מתי, משתמשים בו כדי לשאול על זמן. למשל: When is your birthday? — מתי יום ההולדת שלך?'),
    VocabWord(id:'why', english:'why', hebrew:'למה', category:'questions', world:23, explanation:'why פירושו למה, משתמשים בו כדי לשאול על סיבה. למשל: Why are you sad? — למה אתה עצוב?'),
    VocabWord(id:'how', english:'how', hebrew:'איך', category:'questions', world:23, explanation:'how פירושו איך, משתמשים בו כדי לשאול על דרך או אופן. למשל: How are you? — איך אתה?'),
    VocabWord(id:'which', english:'which', hebrew:'איזה/איזו', category:'questions', world:23, explanation:'which פירושו איזה או איזו, משתמשים בו כשבוחרים מתוך כמה אפשרויות. למשל: Which color do you like? — איזה צבע אתה אוהב?'),
    VocabWord(id:'because', english:'because', hebrew:'כי', category:'structure', world:23, explanation:'because פירושו כי או בגלל ש, משתמשים בו כדי להסביר סיבה. למשל: I am happy because I see my friend — אני שמח כי אני רואה את החבר שלי.'),
    VocabWord(id:'with', english:'with', hebrew:'עם', category:'structure', world:23, explanation:'with פירושו עם, משתמשים בו כשמדברים על משהו ביחד. למשל: I play with my friend — אני משחק עם החבר שלי.'),
    VocabWord(id:'from', english:'from', hebrew:'מ-', category:'structure', world:23, explanation:'from פירושו מ- או מאת, משתמשים בו כדי לתאר מקור. למשל: I am from Israel — אני מישראל.'),
    VocabWord(id:'to', english:'to', hebrew:'אל/ל-', category:'structure', world:23, explanation:'to פירושו אל או ל-, משתמשים בו כדי לתאר כיוון או יעד. למשל: I go to school — אני הולך לבית הספר.'),
    VocabWord(id:'for', english:'for', hebrew:'בשביל', category:'structure', world:23, explanation:'for פירושו בשביל או עבור. למשל: This is for you — זה בשבילך.'),
    VocabWord(id:'but', english:'but', hebrew:'אבל', category:'structure', world:23, explanation:'but פירושו אבל, משתמשים בו כדי להראות ניגוד. למשל: I am tired, but I am happy — אני עייף, אבל אני שמח.'),

    // World 24 — Let's Read
    VocabWord(id:'know', english:'know', hebrew:'יודע/ת', category:'verbs', world:24),
    VocabWord(id:'think', english:'think', hebrew:'חושב/ת', category:'verbs', world:24),
    VocabWord(id:'find', english:'find', hebrew:'מוצא/ת', category:'verbs', world:24),
    VocabWord(id:'tell', english:'tell', hebrew:'מספר/ת', category:'verbs', world:24),
    VocabWord(id:'ask', english:'ask', hebrew:'שואל/ת', category:'verbs', world:24),
    VocabWord(id:'answer', english:'answer', hebrew:'עונה/תשובה', category:'verbs', world:24),
    VocabWord(id:'something', english:'something', hebrew:'משהו', category:'structure', world:24),
    VocabWord(id:'very', english:'very', hebrew:'מאוד', category:'structure', world:24),
    VocabWord(id:'more', english:'more', hebrew:'עוד/יותר', category:'structure', world:24),
    VocabWord(id:'again', english:'again', hebrew:'שוב', category:'structure', world:24),
  ];

  static VocabWord word(String id) => words.firstWhere((w) => w.id == id);

  static final lessons = _buildLessons();

  static List<Lesson> _buildLessons() {
    const plans = <int, List<(String, List<String>)>>{
      1: [('CAT',['cat']),('DOG',['dog','cat']),('PIG',['pig','dog']),('FISH + FROG',['fish','frog']),('BIRD + DUCK',['bird','duck']),('Checkpoint',[]),('Boss: First Words',[])],
      2: [('I + A',['i','a']),('SEE',['see']),('I see a...',['i','see','a']),('THIS + THAT',['this','that']),('IS',['is']),('Checkpoint',[]),('Boss: I see a dog',[])],
      3: [('RED + BLUE',['red','blue']),('GREEN + YELLOW',['green','yellow']),('BLACK + WHITE',['black','white']),('PINK + ORANGE',['pink','orange']),('Colors in sentences',[]),('Checkpoint',[]),('Boss: Colors',[])],
      4: [('I AM',['am']),('HAPPY + SAD',['happy','sad']),('BIG + SMALL',['big','small']),('GOOD + BAD',['good','bad']),('Describe it',[]),('Checkpoint',[]),('Boss: About Me',[])],
      5: [('HE + SHE',['he','she']),('BOY + GIRL',['boy','girl']),('IT',['it']),('YOU + WE + THEY',['you','we','they']),('ARE',['are']),('Checkpoint',[]),('Boss: People',[])],
      6: [('MOM + DAD',['mom','dad']),('BABY + MAN + WOMAN',['baby','man','woman']),('FRIEND',['friend']),('MY + YOUR',['my','your']),('This is my...',[]),('Checkpoint',[]),('Boss: Family',[])],
      7: [('APPLE + BANANA + AN',['apple','banana','an']),('PIZZA + BREAD + EGG',['pizza','bread','egg']),('MILK + WATER',['milk','water']),('CAKE + RICE + CHEESE',['cake','rice','cheese']),('LIKE + EAT + DRINK + WANT',['like','eat','drink','want']),('Checkpoint',[]),('Boss: Food',[])],
      8: [('ONE + TWO',['one','two']),('THREE + FOUR',['three','four']),('FIVE + SIX',['five','six']),('SEVEN + EIGHT',['seven','eight']),('NINE + TEN + HAVE/HAS',['nine','ten','have','has']),('Checkpoint',[]),('Boss: Numbers',[])],
      9: [('CAN + GO',['can','go']),('RUN + WALK',['run','walk']),('JUMP + SIT',['jump','sit']),('STAND + PLAY',['stand','play']),('READ + LOOK',['read','look']),('Checkpoint',[]),('Boss: Actions',[])],
      10:[('HOUSE + CAR + BUS',['house','car','bus']),('BALL + BOOK',['ball','book']),('BED + CHAIR',['bed','chair']),('TABLE + DOOR',['table','door']),('BAG',['bag']),('Checkpoint',[]),('Boss: My Things',[])],
      11:[('WHERE + HERE + THERE',['where','here','there']),('IN + ON',['in','on']),('UNDER',['under']),('UP + DOWN',['up','down']),('OPEN + CLOSE',['open','close']),('Checkpoint',[]),('Boss: Where?',[])],
      12:[('WHAT + WHO',['what','who']),('DO + NOT',['do','not']),('YES + NO + AND',['yes','no','and']),('THE',['the']),('OLD + NEW',['old','new']),('HOT + COLD + FAST + SLOW',['hot','cold','fast','slow']),('FINAL BOSS',[])],
      13:[('HEAD + HAND',['head','hand']),('LEG + FOOT',['leg','foot']),('EYE + EAR',['eye','ear']),('NOSE + MOUTH',['nose','mouth']),('HAIR + FACE',['hair','face']),('Checkpoint',[]),('Boss: My Body',[])],
      14:[('SHIRT + PANTS',['shirt','pants']),('SHOES + SOCKS',['shoes','socks']),('DRESS + HAT',['dress','hat']),('COAT + SHORTS',['coat','shorts']),('WEAR + CLOTHES',['wear','clothes']),('Checkpoint',[]),('Boss: Clothes',[])],
      15:[('SCHOOL + TEACHER',['school','teacher']),('CLASS + PEN',['class','pen']),('PENCIL + PAPER',['pencil','paper']),('DESK + STUDENT',['desk','student']),('WRITE + LEARN',['write','learn']),('Checkpoint',[]),('Boss: School',[])],
      16:[('ROOM + KITCHEN',['room','kitchen']),('BATHROOM + BEDROOM',['bathroom','bedroom']),('WINDOW + FLOOR',['window','floor']),('WALL + LIGHT',['wall','light']),('INSIDE + OUTSIDE',['inside','outside']),('Checkpoint',[]),('Boss: Home',[])],
      17:[('MORNING + NIGHT',['morning','night']),('WAKE + SLEEP',['wake','sleep']),('WASH + START',['wash','start']),('FINISH + TODAY',['finish','today']),('NOW + LATER',['now','later']),('Checkpoint',[]),('Boss: My Day',[])],
      18:[('COME + GIVE',['come','give']),('TAKE + MAKE',['take','make']),('HELP + STOP',['help','stop']),('PUT + GET',['put','get']),('SAY + LISTEN',['say','listen']),('Checkpoint',[]),('Boss: More Actions',[])],
      19:[('ANGRY + TIRED',['angry','tired']),('HUNGRY + THIRSTY',['hungry','thirsty']),('SCARED + FUNNY',['scared','funny']),('NICE + OKAY',['nice','okay']),('LOVE + FEEL',['love','feel']),('Checkpoint',[]),('Boss: Feelings',[])],
      20:[('SUN + RAIN',['sun','rain']),('CLOUD + WIND',['cloud','wind']),('SKY + SUNNY',['sky','sunny']),('RAINY + WARM',['rainy','warm']),('WEATHER + STORM',['weather','storm']),('Checkpoint',[]),('Boss: Weather',[])],
      21:[('PARK + STORE',['park','store']),('STREET + CITY',['street','city']),('BEACH + SEA',['beach','sea']),('ROAD + HOME',['road','home']),('SHOP + PLACE',['shop','place']),('Checkpoint',[]),('Boss: Places',[])],
      22:[('DAY + WEEK',['day','week']),('HOUR + MINUTE',['hour','minute']),('BEFORE + AFTER',['before','after']),('EARLY + LATE',['early','late']),('YESTERDAY + TOMORROW',['yesterday','tomorrow']),('Checkpoint',[]),('Boss: Time',[])],
      23:[('WHEN + WHY',['when','why']),('HOW + WHICH',['how','which']),('BECAUSE + WITH',['because','with']),('FROM + TO',['from','to']),('FOR + BUT',['for','but']),('Checkpoint',[]),('Boss: Questions',[])],
      24:[('KNOW + THINK',['know','think']),('FIND + TELL',['find','tell']),('ASK + ANSWER',['ask','answer']),('SOMETHING + VERY',['something','very']),('MORE + AGAIN',['more','again']),('Checkpoint',[]),('FINAL BOSS',[])],
    };

    final sentenceBanks = <String, List<String>>{
      '2:I see a...': ['I see a dog.', 'I see a cat.', 'This is a dog.'],
      '2:Boss: I see a dog': ['I see a dog.', 'This is a cat.', 'I see a pig.'],
      '3:Colors in sentences': ['The dog is red.', 'I see a blue cat.', 'This is a green frog.'],
      '3:Boss: Colors': ['The cat is black.', 'I see a pink pig.', 'This is a white duck.'],
      '4:Describe it': ['I am happy.', 'The dog is big.', 'I am not sad.'],
      '4:Boss: About Me': ['I am happy.', 'The dog is small.', 'I am good.'],
      '5:Boss: People': ['They are happy.', 'He is a boy.', 'She is a girl.'],
      '6:This is my...': ['This is my mom.', 'This is my dad.', 'This is my friend.'],
      '6:Boss: Family': ['This is my mom.', 'This is my friend.', 'He is my dad.'],
      '7:Boss: Food': ['I like pizza.', 'I want water.', 'I eat an apple.'],
      '8:Boss: Numbers': ['I have two cats.', 'She has one dog.', 'I see three pigs.'],
      '9:Boss: Actions': ['I can run.', 'They can jump.', 'He can read.'],
      '10:Boss: My Things': ['My book is on the table.', 'The ball is under the chair.', 'I see my bag.'],
      '11:Boss: Where?': ['The ball is under the table.', 'The dog is on the bed.', 'Where is my book?'],
      '12:FINAL BOSS': ['The dog is not big.', 'I like the red ball.', 'What is this?'],
      '13:Boss: My Body': ['I see my hand.', 'This is my face.', 'My eyes are big.'],
      '14:Boss: Clothes': ['I wear a red shirt.', 'This is my hat.', 'My shoes are new.'],
      '15:Boss: School': ['I go to school.', 'The teacher is nice.', 'I write with a pen.'],
      '16:Boss: Home': ['I am in my room.', 'The window is big.', 'My bed is inside.'],
      '17:Boss: My Day': ['I wake up in the morning.', 'I sleep at night.', 'I finish my food.'],
      '18:Boss: More Actions': ['Can you help me?', 'I give you a book.', 'Please listen to me.'],
      '19:Boss: Feelings': ['I feel happy today.', 'She is tired.', 'He is hungry.'],
      '20:Boss: Weather': ['It is sunny today.', 'I see a big cloud.', 'The weather is warm.'],
      '21:Boss: Places': ['I go to the park.', 'The store is in the city.', 'We are at the beach.'],
      '22:Boss: Time': ['See you tomorrow.', 'I wake up early.', 'The class is after lunch.'],
      '23:Boss: Questions': ['Why are you happy?', 'This is for you.', 'I am tired, but I am happy.'],
      '24:FINAL BOSS': ['I think I know the answer.', 'Can you tell me more?', 'I want to ask a question.'],
    };

    final result = <Lesson>[];
    var id = 1;
    for (var world = 1; world <= 24; world++) {
      final plan = plans[world]!;
      for (var i = 0; i < plan.length; i++) {
        result.add(Lesson(
          id: id++,
          world: world,
          indexInWorld: i + 1,
          title: plan[i].$1,
          focusWordIds: plan[i].$2,
          checkpoint: plan[i].$1 == 'Checkpoint',
          boss: plan[i].$1.contains('Boss') || plan[i].$1.contains('BOSS'),
          sentenceBank: sentenceBanks['$world:${plan[i].$1}'] ?? const [],
        ));
      }
    }
    return result;
  }

  // ── Mini-stories (reading comprehension) ────────────────────────────
  //
  // Each story uses only vocabulary already taught up to that world
  // (cumulative), so a child can always read it with what they already
  // know. World 1 has no story — sentence structure (is/a/this/that)
  // doesn't exist until World 2, matching the same rule used for the
  // "Build a Sentence" exercise.
  static const stories = <Story>[
    Story(world:2, title:'הכלב והפרה', sentences:['I see a dog.','This is a cow.'], questions:[
      ComprehensionQuestion(question:'מה זה (this)?', options:['פרה','כלב','חתול'], correctIndex:0),
    ]),
    Story(world:3, title:'צבעים', sentences:['I see a red dog.','This is a blue cat.'], questions:[
      ComprehensionQuestion(question:'איזה צבע החתול?', options:['אדום','כחול','ירוק'], correctIndex:1),
    ]),
    Story(world:4, title:'אני שמח', sentences:['I am happy.','The dog is big.'], questions:[
      ComprehensionQuestion(question:'איך אני מרגיש?', options:['שמח','עצוב','רע'], correctIndex:0),
    ]),
    Story(world:5, title:'ילד וילדה', sentences:['He is a boy.','She is a girl.'], questions:[
      ComprehensionQuestion(question:"מי 'she' בסיפור?", options:['ילד','ילדה','אישה'], correctIndex:1),
    ]),
    Story(world:6, title:'המשפחה שלי', sentences:['This is my mom.','This is my friend.'], questions:[
      ComprehensionQuestion(question:'מי החבר?', options:['חבר','אמא','אבא'], correctIndex:0),
    ]),
    Story(world:7, title:'האוכל שלי', sentences:['I like pizza.','I want water.'], questions:[
      ComprehensionQuestion(question:'מה אני רוצה?', options:['מים','חלב','לחם'], correctIndex:0),
    ]),
    Story(world:8, title:'יש לי חיות', sentences:['I have two cats.','She has one dog.'], questions:[
      ComprehensionQuestion(question:'כמה חתולים יש לי?', options:['אחד','שתיים','שלוש'], correctIndex:1),
    ]),
    Story(world:9, title:'אני יכול!', sentences:['I can run.','They can jump.'], questions:[
      ComprehensionQuestion(question:'מה אני יכול לעשות?', options:['לרוץ','לקפוץ','לשבת'], correctIndex:0),
    ]),
    Story(world:10, title:'הדברים שלי', sentences:['My book is on the table.','The ball is under the bed.'], questions:[
      ComprehensionQuestion(question:'איפה הכדור?', options:['על השולחן','מתחת למיטה','בתיק'], correctIndex:1),
    ]),
    Story(world:11, title:'איפה זה?', sentences:['The dog is under the table.','Where is my book?'], questions:[
      ComprehensionQuestion(question:'איפה הכלב?', options:['על השולחן','מתחת לשולחן','בפנים'], correctIndex:1),
    ]),
    Story(world:12, title:'הכדור האדום', sentences:['The dog is not big.','I like the red ball.'], questions:[
      ComprehensionQuestion(question:'איזה כדור אני אוהב?', options:['אדום','כחול','ירוק'], correctIndex:0),
    ]),
    Story(world:13, title:'הגוף שלי', sentences:['I see my hand.','This is my face.'], questions:[
      ComprehensionQuestion(question:'מה אני רואה?', options:['יד','רגל','אוזן'], correctIndex:0),
    ]),
    Story(world:14, title:'הבגדים שלי', sentences:['I wear a red shirt.','My shoes are new.'], questions:[
      ComprehensionQuestion(question:'איזה צבע החולצה?', options:['אדום','כחול','שחור'], correctIndex:0),
    ]),
    Story(world:15, title:'בבית הספר', sentences:['I go to school.','The teacher is nice.'], questions:[
      ComprehensionQuestion(question:'איך המורה?', options:['נחמד','רע','עצוב'], correctIndex:0),
    ]),
    Story(world:16, title:'הבית שלי', sentences:['I am in my room.','The window is big.'], questions:[
      ComprehensionQuestion(question:'איפה אני?', options:['בחדר','במטבח','בחוץ'], correctIndex:0),
    ]),
    Story(world:17, title:'היום שלי', sentences:['I wake up in the morning.','I sleep at night.'], questions:[
      ComprehensionQuestion(question:'מתי אני ישן?', options:['בבוקר','בלילה','עכשיו'], correctIndex:1),
    ]),
    Story(world:18, title:'בואו נעזור', sentences:['Can you help me?','I give you a book.'], questions:[
      ComprehensionQuestion(question:'מה אני נותן?', options:['ספר','עט','תיק'], correctIndex:0),
    ]),
    Story(world:19, title:'איך אני מרגיש', sentences:['I feel happy today.','She is tired.'], questions:[
      ComprehensionQuestion(question:'איך אני מרגיש?', options:['שמח','עייף','כועס'], correctIndex:0),
    ]),
    Story(world:20, title:'מזג האוויר', sentences:['It is sunny today.','I see a big cloud.'], questions:[
      ComprehensionQuestion(question:'איך מזג האוויר?', options:['שמשי','גשום','קר'], correctIndex:0),
    ]),
    Story(world:21, title:'יוצאים החוצה', sentences:['I go to the park.','We are at the beach.'], questions:[
      ComprehensionQuestion(question:'איפה אנחנו?', options:['בפארק','בחוף','בעיר'], correctIndex:1),
    ]),
    Story(world:22, title:'מתי?', sentences:['See you tomorrow.','I wake up early.'], questions:[
      ComprehensionQuestion(question:'מתי אני מתעורר?', options:['מוקדם','מאוחר','בלילה'], correctIndex:0),
    ]),
    Story(world:23, title:'שאלות', sentences:['Why are you happy?','This is for you.'], questions:[
      ComprehensionQuestion(question:'למי זה?', options:['לך','לי','להם'], correctIndex:0),
    ]),
    Story(world:24, title:'אני חושב', sentences:['I think I know the answer.','Can you tell me more?'], questions:[
      ComprehensionQuestion(question:'מה אני יודע?', options:['את התשובה','את השאלה','כלום'], correctIndex:0),
    ]),
  ];

  // ── ABC — standalone letter-foundation track ────────────────────────
  //
  // Deliberately NOT tied to worlds, lessons, or mastery. Every letter
  // shown lowercase, matching how words appear everywhere else in the
  // app. This exists because some kids can play the word exercises by
  // pattern-matching without actually knowing their letters yet — this
  // gives them a place to build that foundation directly, at their own
  // pace, alongside (not gating) the word track.
  static const alphabet = <AlphabetLetter>[
    AlphabetLetter(letter:'a', soundHint:"נשמע כמו 'אַ' קצרה, כמו במילה cat", exampleWord:'cat'),
    AlphabetLetter(letter:'b', soundHint:"נשמע כמו 'ב', כמו במילה book", exampleWord:'book'),
    AlphabetLetter(letter:'c', soundHint:"נשמע כמו 'ק', כמו במילה cat", exampleWord:'cat'),
    AlphabetLetter(letter:'d', soundHint:"נשמע כמו 'ד', כמו במילה dog", exampleWord:'dog'),
    AlphabetLetter(letter:'e', soundHint:"נשמע כמו 'אֶ' קצרה, כמו במילה egg", exampleWord:'egg'),
    AlphabetLetter(letter:'f', soundHint:"נשמע כמו 'פ', כמו במילה fish", exampleWord:'fish'),
    AlphabetLetter(letter:'g', soundHint:"נשמע כמו 'ג', כמו במילה girl", exampleWord:'girl'),
    AlphabetLetter(letter:'h', soundHint:"נשמע כמו נשיפה קלה, כמו במילה hat", exampleWord:'hat'),
    AlphabetLetter(letter:'i', soundHint:"נשמע כמו 'אִ' קצרה, כמו במילה in", exampleWord:'in'),
    AlphabetLetter(letter:'j', soundHint:"נשמע כמו 'ג׳', כמו במילה jump", exampleWord:'jump'),
    AlphabetLetter(letter:'k', soundHint:"נשמע כמו 'ק', כמו במילה kitchen", exampleWord:'kitchen'),
    AlphabetLetter(letter:'l', soundHint:"נשמע כמו 'ל', כמו במילה look", exampleWord:'look'),
    AlphabetLetter(letter:'m', soundHint:"נשמע כמו 'מ', כמו במילה mom", exampleWord:'mom'),
    AlphabetLetter(letter:'n', soundHint:"נשמע כמו 'נ', כמו במילה nose", exampleWord:'nose'),
    AlphabetLetter(letter:'o', soundHint:"נשמע כמו 'אָ', כמו במילה on", exampleWord:'on'),
    AlphabetLetter(letter:'p', soundHint:"נשמע כמו 'פּ', כמו במילה pig", exampleWord:'pig'),
    AlphabetLetter(letter:'q', soundHint:"נשמע כמו 'קװ', כמו במילה queen", exampleWord:'queen'),
    AlphabetLetter(letter:'r', soundHint:"נשמע כמו 'ר', כמו במילה red", exampleWord:'red'),
    AlphabetLetter(letter:'s', soundHint:"נשמע כמו 'ס', כמו במילה sun", exampleWord:'sun'),
    AlphabetLetter(letter:'t', soundHint:"נשמע כמו 'ט', כמו במילה table", exampleWord:'table'),
    AlphabetLetter(letter:'u', soundHint:"נשמע כמו 'אַ' קצרה, כמו במילה up", exampleWord:'up'),
    AlphabetLetter(letter:'v', soundHint:"נשמע כמו 'ו' רוטטת, כמו במילה very", exampleWord:'very'),
    AlphabetLetter(letter:'w', soundHint:"נשמע כמו 'וו', כמו במילה water", exampleWord:'water'),
    AlphabetLetter(letter:'x', soundHint:"נשמע כמו 'קס', כמו במילה box", exampleWord:'box'),
    AlphabetLetter(letter:'y', soundHint:"נשמע כמו 'י', כמו במילה yes", exampleWord:'yes'),
    AlphabetLetter(letter:'z', soundHint:"נשמע כמו 'ז', כמו במילה zebra", exampleWord:'zebra'),
  ];

  // Common two-letter sound blends that don't correspond to a single
  // alphabet letter but show up constantly in early reading. Examples
  // are drawn from real vocabulary wherever possible.
  static const soundBlends = <SoundBlend>[
    SoundBlend(blend:'sh', soundHint:"נשמע בדיוק כמו 'ש' בעברית, כמו במילה fish", exampleWord:'fish'),
    SoundBlend(blend:'ch', soundHint:"נשמע כמו 'צ'' (טצ'), כמו במילה chair", exampleWord:'chair'),
    SoundBlend(blend:'th', soundHint:"צליל מיוחד — הלשון נוגעת בשיניים, קצת כמו 'ת' רכה. כמו במילה this", exampleWord:'this'),
    SoundBlend(blend:'ck', soundHint:"נשמע כמו 'ק', כמו במילה duck", exampleWord:'duck'),
    SoundBlend(blend:'wh', soundHint:"נשמע כמו 'וו', כמו במילה where", exampleWord:'where'),
    SoundBlend(blend:'ph', soundHint:"נשמע כמו 'פ', כמו במילה phone", exampleWord:'phone'),
  ];

  // Reverse-direction bridge: a Hebrew letter the child already knows,
  // mapped to its closest English letter or blend equivalent. Letters
  // without a clean single match (א, ח, ע, צ) are intentionally left
  // out rather than forcing an inaccurate pairing.
  static const hebrewSoundMatches = <HebrewSoundMatch>[
    HebrewSoundMatch(hebrewLetter:'ב', englishSound:'b', exampleWord:'book'),
    HebrewSoundMatch(hebrewLetter:'ג', englishSound:'g', exampleWord:'girl'),
    HebrewSoundMatch(hebrewLetter:'ד', englishSound:'d', exampleWord:'dog'),
    HebrewSoundMatch(hebrewLetter:'ה', englishSound:'h', exampleWord:'hat'),
    HebrewSoundMatch(hebrewLetter:'ו', englishSound:'v', exampleWord:'very'),
    HebrewSoundMatch(hebrewLetter:'ז', englishSound:'z', exampleWord:'zebra'),
    HebrewSoundMatch(hebrewLetter:'ט', englishSound:'t', exampleWord:'table'),
    HebrewSoundMatch(hebrewLetter:'י', englishSound:'y', exampleWord:'yes'),
    HebrewSoundMatch(hebrewLetter:'כ', englishSound:'k', exampleWord:'kitchen'),
    HebrewSoundMatch(hebrewLetter:'ל', englishSound:'l', exampleWord:'look'),
    HebrewSoundMatch(hebrewLetter:'מ', englishSound:'m', exampleWord:'mom'),
    HebrewSoundMatch(hebrewLetter:'נ', englishSound:'n', exampleWord:'nose'),
    HebrewSoundMatch(hebrewLetter:'ס', englishSound:'s', exampleWord:'sun'),
    HebrewSoundMatch(hebrewLetter:'פ', englishSound:'p', exampleWord:'pig'),
    HebrewSoundMatch(hebrewLetter:'ק', englishSound:'k', exampleWord:'cat'),
    HebrewSoundMatch(hebrewLetter:'ר', englishSound:'r', exampleWord:'red'),
    HebrewSoundMatch(hebrewLetter:'ש', englishSound:'sh', exampleWord:'fish'),
    HebrewSoundMatch(hebrewLetter:'ת', englishSound:'t', exampleWord:'ten'),
  ];
}
