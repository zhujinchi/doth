$(document).ready(function() {
    $('#example').DataTable({
        language: {
            "lengthMenu": "每页显示 _MENU_记录",
            "zeroRecords": "没有匹配的数据",
            "info": "第_PAGE_页/共 _PAGES_页 ( 共\_TOTAL\_条记录 )",
            "infoEmpty": "没有符合条件的记录",
            "search": "查找",
            "infoFiltered": "(从 _MAX_条记录中过滤)",
            oPaginate: {
                sFirst: '<i class="material-icons">chevron_left</i>',
                sPrevious: '<i class="material-icons">chevron_left</i>',
                sNext: '<i class="material-icons">chevron_right</i>',
                sLast: '<i class="material-icons">chevron_right</i>'
        }
        }
    });
    $('.dataTables_length select').addClass('browser-default');
});