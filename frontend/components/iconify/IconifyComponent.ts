import { IconifyIcon } from "#components";
import { h } from "vue";
import type { IconProps } from "vuetify";

interface IconifyCustomIconProps extends IconProps {
  size?: string | number;
}

export const IconifyComponent = (props: IconifyCustomIconProps) => {
  if (Array.isArray(props.icon) || typeof props.icon !== "string") {
    return h(IconifyIcon, {
      icon: "mdi:help",
      width: props.size || "24px",
      height: props.size || "24px",
    });
  }

  let icon = props.icon || "mdi:help";
  if (!icon.includes(":")) {
    icon = `mdi:${icon.replace(/^mdi-/, "")}`;
  }

  return h(IconifyIcon, {
    icon,
    width: props.size || "24px",
    height: props.size || "24px",
  });
};
