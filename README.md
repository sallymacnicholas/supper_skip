[![Code Climate](https://codeclimate.com/github/mikedao/dinner_dash/badges/gpa.svg)](https://codeclimate.com/github/mikedao/dinner_dash) [![Stories in Ready](https://badge.waffle.io/mikedao/dinner_dash.png?label=ready&title=Ready)](http://waffle.io/mikedao/dinner_dash)



## Supper Skip

This jam was brought to you originally by Emily Berkeley, Michael Dao, Krista Nelson and
Nathan Owsiany.

**But it was converted to a multitenancy application and made super awesome by Morgan Miller, Chelsea Worrel and Sally MacNicholas** 

This project is for the third module at the Turing School of Software and
Design.

Full project specifications are available here:
https://github.com/JumpstartLab/curriculum/blob/master/source/projects/supper_skip.markdown

## Notes

To get this to run locally, you need to run the following:

    brew install imagemagick

### Here's what you'll need to do after pulling to get it working on heroku
* `bundle install`
* `git push heroku master`
* `heroku pg:reset`
* `heroku run rake db:schema:load db:seed`
* `heroku open` and look at all the glorious menu/item images
