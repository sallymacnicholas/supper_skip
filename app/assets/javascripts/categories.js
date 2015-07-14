$(document).ready(function () {

  var $nameFilterDropDown = $('#category_filter_name')


  $nameFilterDropDown.on('change', function () {
    var currentName = this.value;
    if (!currentName) { return $('.category').show(); }
    $('.category').each(function (index, category){
      $category = $(category);
      var isInName = $(category).data('name') === currentName;
      $(category).toggle(isInName);
    });
  });

});
