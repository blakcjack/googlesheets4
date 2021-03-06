as_GridCoordinate <- function(x, ...) {
    UseMethod("as_GridCoordinate")
}

#' @export
as_GridCoordinate.default <- function(x, ...) {
  stop_glue(
    "Don't know how to make an instance of {bt('GridCoordinate')} from something of ",
    "class {class_collapse(x)}."
  )
}

#' @export
as_GridCoordinate.range_spec <- function(x, ..., strict = TRUE) {
  grid_range <- as_GridRange(x)

  if (identical(names(grid_range), "sheetId")) {
    return(new("GridCoordinate", sheetId = grid_range$sheetId))
  }

  if (strict) {
    row_index_diff <- grid_range$endRowIndex - grid_range$startRowIndex
    col_index_diff <- grid_range$endColumnIndex - grid_range$startColumnIndex
    if (row_index_diff != 1 || col_index_diff != 1) {
      stop_glue(
        "Range must identify exactly 1 cell:\n",
        "  * Invalid cell range: {x$cell_range}"
      )
    }
  }

  grid_range <- grid_range %>% discard(is.null) %>% discard(is.na)
  new(
    "GridCoordinate",
    sheetId = grid_range$sheetId,
    rowIndex = grid_range$startRowIndex,
    columnIndex = grid_range$startColumnIndex
  )
}
