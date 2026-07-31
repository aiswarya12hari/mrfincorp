import 'package:flutter/material.dart';

class AppPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  final ValueChanged<int> onPageChanged;

  final bool isLoading;

  const AppPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.isLoading = false,
  });

  List<dynamic> _buildPages() {
    if (totalPages <= 5) {
      return List.generate(
        totalPages,
        (index) => index + 1,
      );
    }

    final List<dynamic> pages = [];

    /// Always show first page
    pages.add(1);

    if (currentPage > 3) {
      pages.add('...');
    }

    /// Middle pages
    int start =
        currentPage - 1;

    int end =
        currentPage + 1;

    if (currentPage <= 3) {
      start = 2;
      end = 4;
    }

    if (currentPage >=
        totalPages - 2) {
      start =
          totalPages - 3;

      end =
          totalPages - 1;
    }

    for (
      int i = start;
      i <= end;
      i++
    ) {
      if (i > 1 &&
          i < totalPages) {
        pages.add(i);
      }
    }

    if (currentPage <
        totalPages - 2) {
      pages.add('...');
    }

    /// Always show last page
    pages.add(totalPages);

    return pages;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    final pages =
        _buildPages();

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection:
            Axis.horizontal,

        physics:
            const BouncingScrollPhysics(),

        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 8,
          ),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              /// Previous
              _PaginationButton(
                icon:
                    Icons.chevron_left,

                enabled:
                    currentPage > 1 &&
                    !isLoading,

                onTap: () {
                  if (currentPage >
                          1 &&
                      !isLoading) {
                    onPageChanged(
                      currentPage - 1,
                    );
                  }
                },
              ),

              const SizedBox(
                width: 6,
              ),

              /// Page Numbers
              ...pages.map(
                (page) {
                  if (page ==
                      '...') {
                    return const Padding(
                      padding:
                          EdgeInsets.symmetric(
                        horizontal: 6,
                      ),
                      child: Text(
                        '...',
                        style:
                            TextStyle(
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  final int
                      pageNumber =
                      page as int;

                  final bool
                      isSelected =
                      pageNumber ==
                          currentPage;

                  return Padding(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 3,
                    ),
                    child:
                        _PaginationButton(
                      text:
                          pageNumber
                              .toString(),

                      selected:
                          isSelected,

                      enabled:
                          !isLoading,

                      onTap: () {
                        if (!isSelected &&
                            !isLoading) {
                          onPageChanged(
                            pageNumber,
                          );
                        }
                      },
                    ),
                  );
                },
              ),

              const SizedBox(
                width: 6,
              ),

              /// Next
              _PaginationButton(
                icon:
                    Icons.chevron_right,

                enabled:
                    currentPage <
                        totalPages &&
                    !isLoading,

                onTap: () {
                  if (currentPage <
                          totalPages &&
                      !isLoading) {
                    onPageChanged(
                      currentPage + 1,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaginationButton
    extends StatelessWidget {
  final String? text;
  final IconData? icon;

  final bool selected;
  final bool enabled;

  final VoidCallback onTap;

  const _PaginationButton({
    this.text,
    this.icon,
    this.selected = false,
    this.enabled = true,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return InkWell(
      onTap:
          enabled ? onTap : null,

      borderRadius:
          BorderRadius.circular(
        8,
      ),

      child: Container(
        width: 36,
        height: 36,

        alignment:
            Alignment.center,

        decoration:
            BoxDecoration(
          color: selected
              ? Colors.black
              : Colors.transparent,

          borderRadius:
              BorderRadius.circular(
            8,
          ),

          border:
              Border.all(
            color: selected
                ? Colors.black
                : Colors.grey.shade300,
          ),
        ),

        child: icon != null
            ? Icon(
                icon,
                size: 20,
                color: enabled
                    ? Colors.black
                    : Colors.grey,
              )
            : Text(
                text ?? '',
                style:
                    TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w600,
                  color: selected
                      ? Colors.white
                      : enabled
                          ? Colors.black
                          : Colors.grey,
                ),
              ),
      ),
    );
  }
}