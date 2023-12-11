#include <gtest/gtest.h>
#include "lib.h"

TEST(libTest, BasicAssertions) {
  lib l;
  EXPECT_STRNE("hello", "world");
  EXPECT_EQ(l.add(3,4), 7);
}

TEST(libTest, BasicAssertions2) {
  lib l;
  EXPECT_EQ(l.add(4,4), 8);
}
