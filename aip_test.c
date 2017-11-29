#include <stdlib.h>
#include <check.h>
#include "aip.h"

START_TEST(test_aip_pton4) {
  unsigned long ip;
  // valid
  ck_assert_uint_eq(aip_pton4("192.168.1.1", &ip), 0);
  ck_assert_uint_eq(ip, 3232235777);
  ck_assert_uint_eq(aip_pton4("127.0.0.1", &ip), 0);
  ck_assert_uint_eq(ip, 2130706433);
  ck_assert_uint_eq(aip_pton4("0.0.0.0", &ip), 0);
  ck_assert_uint_eq(ip, 0);
  ck_assert_uint_eq(aip_pton4("255.255.255.255", &ip), 0);
  ck_assert_uint_eq(ip, 4294967295);
  // invalid
  ck_assert_uint_eq(aip_pton4("192.168.1.1.", &ip), 1);
  ck_assert_uint_eq(aip_pton4(".192.168.1.1", &ip), 1);
  ck_assert_uint_eq(aip_pton4("256.168.1.1", &ip), 1);
  ck_assert_uint_eq(aip_pton4("A.168.1.1", &ip), 1);
  ck_assert_uint_eq(aip_pton4("192", &ip), 1);
  ck_assert_uint_eq(aip_pton4("192..168.1", &ip), 1);
  ck_assert_uint_eq(aip_pton4("", &ip), 1);
  ck_assert_uint_eq(aip_pton4(".", &ip), 1);
}
END_TEST

Suite * aip_suite() {
  Suite *s = suite_create("aip");
  TCase *tc_core = tcase_create("core");
  tcase_add_test(tc_core, test_aip_pton4);
  suite_add_tcase(s, tc_core);
  return s;
}

int main() {
  Suite *s = aip_suite();
  SRunner *sr = srunner_create(s);
  srunner_run_all(sr, CK_NORMAL);
  int number_failed = srunner_ntests_failed(sr);
  srunner_free(sr);
  return (number_failed == 0) ? EXIT_SUCCESS : EXIT_FAILURE;
}
