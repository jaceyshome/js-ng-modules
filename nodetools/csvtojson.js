/**
 * Created by Jaceyshome on 27/01/14.
 */


var csv = require("./csv.js");

var json = csv.parse('tmp/category.csv');
csv.write('./src/assets/category.json');

var json = csv.parse('tmp/quicklinks.csv');
csv.write('./src/assets/quicklinks.json');

var json = csv.parse('tmp/category-webs.csv');
csv.write('./src/assets/category-webs.json');