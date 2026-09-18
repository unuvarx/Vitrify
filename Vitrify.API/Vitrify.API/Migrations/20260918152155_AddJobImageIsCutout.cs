using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Vitrify.API.Migrations
{
    /// <inheritdoc />
    public partial class AddJobImageIsCutout : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsCutout",
                table: "JobImages",
                type: "boolean",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsCutout",
                table: "JobImages");
        }
    }
}
